# frozen_string_literal: true

class Task < ApplicationRecord
  validates :completed_at, presence: true

  belongs_to :habit

  after_save :update_habit_progress, if: :saved_change_to_completed_at?

  def update_habit_progress
    habit.update_progress
  end
end
