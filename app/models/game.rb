class Game < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :field

  belongs_to :home, class_name: 'Team', foreign_key: :home_id
  belongs_to :away, class_name: 'Team', foreign_key: :away_id

  has_many :score_reports, dependent: :destroy
  has_many :score_entries, dependent: :destroy
  has_many :score_disputes, dependent: :destroy

  validates_presence_of :tournament,
                        :division,
                        :home_prereq,
                        :away_prereq,
                        :round
  validates_presence_of :pool, if: Proc.new{ |g| g.bracket_uid.nil? }
  validates_presence_of :bracket_uid, if: Proc.new{ |g| g.pool.nil? }
  validates_uniqueness_of :bracket_uid, scope: :division, if: :bracket_game?
  validates_presence_of :home_pool_seed, :away_pool_seed, if: :pool_game?

  validates :start_time, date: true, if: Proc.new{ |g| g.start_time.present? }
  validates_presence_of :start_time, if: Proc.new{ |g| g.field.present? }
  validates_presence_of :field, if: Proc.new{ |g| g.start_time.present? }
  validate :validate_field

  validates_numericality_of :home_score, :away_score, allow_blank: true, greater_than_or_equal_to: 0

  before_save :set_confirmed
  after_save :broadcast

  scope :bracket_game, -> { where.not(bracket_uid: nil) }

  scope :assigned, -> { where.not(field_id: nil, start_time: nil) }
  scope :with_teams, -> { where('home_id IS NOT NULL or away_id IS NOT NULL') }
  scope :reported_unconfirmed, -> { includes(:score_reports).where(score_confirmed: false).where.not(score_reports: {id: nil})}

  def self.create_from_template!(tournament_id:, division_id:, template_game:)
    Game.create!(
      template_game.merge(
        tournament_id: tournament_id,
        division_id: division_id
      )
    )
  end

  def [](key)
    return home_name if key == :home_name
    return away_name if key == :away_name
    super
  end

  def pool_game?
    pool.present?
  end

  def bracket_game?
    bracket_uid.present?
  end

  def tie?
    home_score == away_score
  end

  def winner
    return if home_score == away_score
    home_score > away_score ? home : away
  end

  def loser
    return if home_score == away_score
    home_score < away_score ? home : away
  end

  def home_name
    home.present? ? home.name : home_prereq
  end

  def away_name
    away.present? ? away.name : away_prereq
  end

  def one_team_present?
    home.present? || away.present?
  end

  def teams_present?
    home.present? && away.present?
  end

  def scheduled?
    field_id && start_time
  end

  def played?
    return unless start_time
    Time.now > end_time
  end

  def end_time
    start_time + tournament.time_cap.minutes
  end

  def playing_time_range
    (start_time)..(end_time - 1.minutes)
  end

  def playing_time_range_string
    formatted_start = start_time.to_formatted_s(:timeonly)
    formatted_end = end_time.to_formatted_s(:timeonly)
    "#{formatted_start} - #{formatted_end}"
  end

  def confirmed?
    score_confirmed
  end

  def unconfirmed?
    !score_confirmed
  end

  def scores_present?
    home_score.present? && away_score.present?
  end

  def reset_score!
    self.home_score = nil
    self.away_score = nil
    self.score_reports.destroy_all
  end

  def dependent_games
    [
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq: "W#{bracket_uid}"),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, home_prereq: "L#{bracket_uid}"),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq: "W#{bracket_uid}"),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, away_prereq: "L#{bracket_uid}")
    ].compact
  end

  def prerequisite_games
    [
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, bracket_uid: home_prereq.to_s.gsub(/W|L/,'')),
      Game.bracket_game.find_by(tournament_id: tournament_id, division_id: division_id, bracket_uid: away_prereq.to_s.gsub(/W|L/,'')),
    ].compact
  end

  def resolve_disputes!
    score_disputes.map(&:resolve!)
    score_disputes.reload
  end

  private

  def broadcast
    ActionCable.server.broadcast(
      "games_#{tournament_id}",
      Admin::GamesController.render(
        template: 'admin/games/_game.json.jbuilder',
        layout: false,
        locals: {game: self}
      )
    )
  end

  def set_confirmed
    self.score_confirmed = self.home_score.present? && self.away_score.present?
    true
  end

  def validate_field
    return if field_id.blank? || errors[:field].present?
    errors.add(:field, 'is invalid') unless tournament.fields.where(id: field_id).exists?
  end
end
