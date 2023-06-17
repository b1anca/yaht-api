# frozen_string_literal: true

class Habit < ApplicationRecord
  validates :name, presence: true
  validates :color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/,
                              message: 'must be a valid hex color' },
                    allow_blank: true

  # TODO: reminder, regularity, completion rates?
  belongs_to :user
  has_many :tasks, dependent: :destroy

  def update_progress
    days_since_creation = (Time.zone.today - created_at.to_date).to_i
    completed_tasks = tasks.where.not(completed_at: nil).count

    if days_since_creation.zero?
      update(overall_progress: 0)
    else
      update(overall_progress: (completed_tasks / days_since_creation.to_f) * 100)
    end
  end
end
