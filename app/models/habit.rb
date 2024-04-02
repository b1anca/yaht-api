# frozen_string_literal: true

class Habit < ApplicationRecord
  validates :name, presence: true
  validates :color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/,
                              message: 'must be a valid hex color' },
                    allow_blank: true

  belongs_to :user

  has_many :tasks, dependent: :destroy

  default_scope { order(:id) }
end
