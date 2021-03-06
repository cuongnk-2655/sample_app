class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true, uniqueness: true,
    format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.email.max_length, minimum: Settings.email.min_length}
  validates :name, presence: true,
    length: {maximum: Settings.name.max_length, minimum: Settings.name.min_length}

  before_save{email.downcase!}
  before_create :create_activation_digest

  scope :sort_by_new, ->{order created_at: :desc}

  has_secure_password

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
