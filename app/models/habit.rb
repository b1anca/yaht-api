# frozen_string_literal: true

class Habit < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :tasks, dependent: :destroy
end
