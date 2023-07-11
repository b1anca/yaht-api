# frozen_string_literal: true

class Habit < ApplicationRecord
  validates :name, presence: true
  validates :color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/,
                              message: 'must be a valid hex color' },
                    allow_blank: true

  # TODO: reminder, regularity, completion rates?
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  default_scope { order(:id) }

  def earliest_date
    [tasks.minimum(:completed_at)&.to_date || Time.zone.today, created_at.to_date].min
  end

  def update_progress
    days_since_earliest_date = (Time.zone.tomorrow - earliest_date).to_i
    completed_tasks = tasks.where.not(completed_at: nil).count
    overall_progress = (completed_tasks / days_since_earliest_date.to_f) * 100

    update(overall_progress:)
  end

  def update_streaks
    streaks = calculate_streaks
    update(current_streak: streaks[:current_streak], record_streak: streaks[:record_streak])
  end

  private

  def calculate_streaks
    tasks = self.tasks.order(:completed_at)
    return { current_streak: 0, record_streak: 0 } if tasks.empty?

    current_streak, record_streak = calculate_task_streaks(tasks)

    { current_streak:, record_streak: }
  end

  def calculate_task_streaks(tasks)
    current_streak = record_streak = 1

    tasks.each_cons(2) do |previous_task, task|
      day_diff = (task.completed_at.to_date - previous_task.completed_at.to_date).to_i
      current_streak = day_diff == 1 ? current_streak + 1 : 1
      record_streak = [record_streak, current_streak].max
    end

    [current_streak, record_streak]
  end
end
