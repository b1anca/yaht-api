# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 10, on: :create }

  has_many :habits, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy
end
