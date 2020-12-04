# frozen_string_literal: true

class User < ApplicationRecord
  attr_writer :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :timeoutable, authentication_keys: [:login]

  has_one_attached :avatar

  validates :mobile, presence: true,
                     uniqueness: true,
                     format: { with: /\A1[3-9]\d{9}\z/ },
                     unless: proc { |u| u.new_record? && u.guest? }
  # validates :username, uniqueness: true, format: { with: /\A[a-zA-Z0-9_.]*\z/i }
  validates :email, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/i }

  scope :guests, -> { where(guest: true) }

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.mobile = Faker::PhoneNumber.phone_number
      # user.name = auth.info.name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  # override devise method to query user
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).find_by('mobile = :val OR email = :val', { val: login.downcase })
  end

  # override devise method to copy data from omniauth
  def self.new_with_session(params, session)
    super.tap do |user|
      data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
      user.email = data['email'] if data && user.email.blank?
    end
  end

  def admin?
    id == 1
  end
end
