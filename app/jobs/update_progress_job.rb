# frozen_string_literal: true

class UpdateProgressJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Habit.find_each do |habit|
      habit.update_progress
      habit.update_streaks
    end
  end
end
