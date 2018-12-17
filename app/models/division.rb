class Division < ApplicationRecord
  include Limits
  LIMIT = 12

  attr_reader :change_message

  belongs_to :tournament

  has_many :seeds, dependent: :destroy
  has_many :teams, through: :seeds

  has_many :games, dependent: :destroy
  has_many :bracket_games, -> { bracket_game }, class_name: 'Game'
  has_many :pool_games, -> (pool_uid) { pool_game(pool_uid) }, class_name: 'Game'

  has_many :pool_results, dependent: :destroy
  has_many :places, dependent: :destroy

  auto_strip_attributes :name

  validates :name, presence: true, uniqueness: { scope: :tournament }
  validates :num_teams, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :num_days, presence: true, numericality: {greater_than_or_equal_to: 0}
  validate :validate_bracket_type

  scope :un_seeded, -> { where(seeded: false) }

  def bracket
    @bracket ||= BracketDb.find(handle: self.bracket_type)
  end

  delegate :template, to: :bracket

  def pools
    bracket.pools.map{ |p| Pool.new(self, p) }
  end

  def dirty_seed?
    DirtySeedCheck.perform(self)
  end

  def safe_to_change?
    return true unless self.bracket_type_changed?
    check = SafeToUpdateBracketCheck.new(self)
    check.perform
    @change_message = check.output
    safe = check.succeeded?
    safe
  end

  def safe_to_seed?
    !games.where(score_confirmed: true).exists?
  end

  def safe_to_delete?
    !games.where(score_confirmed: true).exists?
  end

  def validate_bracket_type
    errors.add(:bracket_type, 'is invalid') unless bracket.present?
  end
end
