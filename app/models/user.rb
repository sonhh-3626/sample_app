class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :microposts, dependent: :destroy

  before_save :downcase_email
  before_create :create_activation_digest
  before_save{self.email = email.downcase}

  PERMITTED_ATTRIBUTES = %w(name email password password_confirmation).freeze
  RESET_PW_PERMITTED_ATTRIBUTES = %w(password password_confirmation).freeze

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
            length:   {
              minimum: Settings.MIN_LENGTH_PASSWORD,
              message: I18n.t("users.error.password_length",
                              count: Settings.MIN_LENGTH_PASSWORD)
            },
            allow_nil: true

  has_secure_password

  scope :activated, ->{where(activated: true)}
  scope :order_by_name, ->{activated.order(name: :asc)}

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

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.PASSWORD_RESET_EXPIRATION_2.hours.ago
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute :reset_digest, User.digest(reset_token)
    update_attribute :reset_sent_at, Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

  def downcase_email
    email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
