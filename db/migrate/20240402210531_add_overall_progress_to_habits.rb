# frozen_string_literal: true

class AddOverallProgressToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :overall_progress, :decimal, precision: 5, scale: 2, default: 0.0
  end
end
