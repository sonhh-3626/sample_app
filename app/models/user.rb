class User < ApplicationRecord
  attr_accessor :remember_token

  PERMITTED_ATTRIBUTES = %w(name email password password_confirmation).freeze
  before_save{self.email = email.downcase}

  validates :name,
            presence: true,
            length: {maximum: Settings.MAX_LENGTH_USERNAME}

  validates :email,
            presence: true,
            format: {with: Rails.application.config.email_regex},
            length: {maximum: Settings.MAX_LENGTH_EMAIL},
            uniqueness: {case_sensitive: false}

  validates :password,
            presence: true,
            length: {minimum: Settings.MIN_LENGTH_PASSWORD}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
