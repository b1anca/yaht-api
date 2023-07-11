# frozen_string_literal: true

namespace :habits do
  desc 'Calculate streaks for existing habits'
  task calculate_streaks: :environment do
    Habit.find_each do |habit|
      tasks = habit.tasks.order(:completed_at)

      current_streak = 1
      record_streak = 0
      previous_task = tasks.first

      tasks[1..].each do |task|
        if task.completed_at.to_date == previous_task.completed_at.to_date + 1.day
          current_streak += 1
        else
          current_streak = 1
        end

        record_streak = [record_streak, current_streak].max
        previous_task = task
      end

      habit.update(current_streak:, record_streak:)
    end
  end
end
