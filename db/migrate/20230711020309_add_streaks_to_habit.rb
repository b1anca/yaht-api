# frozen_string_literal: true

class AddStreaksToHabit < ActiveRecord::Migration[7.0]
  def change
    change_table :habits, bulk: true do |t|
      t.integer :current_streak, default: 0
      t.integer :record_streak, default: 0
    end
  end
end
