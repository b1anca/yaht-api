# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.datetime :completed_at
      t.references :habit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
