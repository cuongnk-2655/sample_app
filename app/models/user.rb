class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :email, presence: true, uniqueness: true,
    format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.email.max_length, minimum: Settings.email.min_length}
  validates :name, presence: true,
    length: {maximum: Settings.name.max_length, minimum: Settings.name.min_length}

  has_secure_password
end
