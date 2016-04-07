class Field < ActiveRecord::Base
  include Limits
  LIMIT = 64

  has_many :games
  belongs_to :tournament

  validates_presence_of :tournament, :name
  validates_uniqueness_of :name, scope: :tournament
  validates :lat , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :long, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :geo_json, json: true

  after_destroy :unassign_games

  serialize :geo_json, JSON

  def safe_to_delete?
    !Game.where(tournament_id: tournament_id, field_id: id).exists?
  end

  private

  def unassign_games
    Fields::UnassignGamesJob.perform_later(
      tournament_id: tournament_id,
      field_id: id
    )
  end
end
