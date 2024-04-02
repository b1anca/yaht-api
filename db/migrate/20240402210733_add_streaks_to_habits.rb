# frozen_string_literal: true

class AddStreaksToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :current_streak, :integer
    add_column :habits, :record_streak, :integer
  end
end
