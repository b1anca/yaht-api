# frozen_string_literal: true

class Task < ApplicationRecord
  validates :completed_at, presence: true
  # TODO: prevent tasks to be completed at the same day

  belongs_to :habit

  after_save :update_habit, if: :saved_change_to_completed_at?
  after_destroy :update_habit

  def update_habit
    habit.update_progress
    habit.update_streaks
  end
end
