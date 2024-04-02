# frozen_string_literal: true

class Habit < ApplicationRecord
  validates :name, presence: true
  validates :color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/,
                              message: 'must be a valid hex color' },
                    allow_blank: true

  # TODO: reminder, regularity, completion rates?
  belongs_to :user
  has_many :tasks, dependent: :destroy

  delegate :time_zone, to: :user

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
    Time.use_zone(time_zone) do
      tasks = self.tasks.order(:completed_at)
      return { current_streak: 0, record_streak: 0 } if tasks.empty?

      current_streak, record_streak = calculate_task_streaks(tasks)

      { current_streak:, record_streak: }
    end
  end

  def calculate_task_streaks(tasks)
    tasks = tasks.sort_by(&:completed_at)
    today = Time.zone.today
    record_streak = current_streak = 0
    last_date = nil

    tasks.each do |task|
      task_date = task.completed_at.in_time_zone.to_date
      last_date, current_streak, record_streak = task_streaks(last_date,
                                                              task_date, current_streak, record_streak)
    end

    # Reset current streak if no task was completed today
    current_streak = 0 if last_date != today

    [current_streak, record_streak]
  end

  def task_streaks(last_date, task_date, current_streak, record_streak)
    if last_date
      day_diff = (task_date - last_date).to_i
      current_streak = day_diff == 1 ? current_streak + 1 : 1
    else
      current_streak = 1 # Start the streak with the first task
    end

    last_date = task_date
    record_streak = [record_streak, current_streak].max

    [last_date, current_streak, record_streak]
  end
end
