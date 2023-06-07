# frozen_string_literal: true

class AddColorToHabits < ActiveRecord::Migration[7.0]
  def change
    add_column :habits, :color, :string
  end
end
