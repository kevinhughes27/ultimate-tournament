class User < ApplicationRecord
  include Staff

  has_many :user_authentications, dependent: :destroy
  has_many :tournament_users, dependent: :destroy
  has_many :tournaments, through: :tournament_users

  devise :invitable,
         :omniauthable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  # knock expects `authenticate`, devise provides `valid_password?`
  alias :authenticate :valid_password?

  def self.from_omniauth(auth)
    authentication = UserAuthentication.where(provider: auth.provider, uid: auth.uid.to_s).first_or_initialize

    if authentication.user.blank?
      user = User.find_by(email: auth.info.email)
      user = User.create!(email: auth.info.email, password: Devise.friendly_token[0, 20]) if user.blank?
      authentication.user = user
      authentication.save!
    end
    authentication.user
  end

  def name
    email.split('@').first
  end

  def is_tournament_user?(tournament)
    tournaments.exists?(id: tournament.id)
  end
end
