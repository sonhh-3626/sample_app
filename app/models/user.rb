class User < ApplicationRecord
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
end
