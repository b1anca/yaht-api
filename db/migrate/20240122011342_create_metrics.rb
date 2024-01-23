# frozen_string_literal: true

class CreateMetrics < ActiveRecord::Migration[7.0]
  def change
    create_table :metrics do |t|
      t.references :metricable, polymorphic: true, null: false
      t.integer :unit, null: false
      t.integer :value, null: false
      t.datetime :measured_on, null: false

      t.timestamps
    end
  end
end
