class Team < ApplicationRecord
  include Limits
  LIMIT = 256

  belongs_to :tournament
  has_one :seed, dependent: :destroy
  has_many :score_reports, dependent: :nullify

  auto_strip_attributes :name, :email, :phone

  validates :name, presence: true, uniqueness: { scope: :tournament }
  validates :email, format: { with: Devise.email_regexp, allow_blank: true }
  validates :phone, phone: { possible: true, allow_blank: true }

  def allow_delete?
    !assigned_to_games?
  end

  private

  def assigned_to_games?
    Game.where(tournament_id: tournament_id, home_id: id).exists? ||
    Game.where(tournament_id: tournament_id, away_id: id).exists?
  end
end
