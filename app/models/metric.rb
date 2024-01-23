class Metric < ApplicationRecord
  belongs_to :metricable, polymorphic: true

  enum unit: { minutes: 0, pages: 1, count: 2, distance_km: 3, calories: 4 }

  validates :value, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :unit, presence: true
  validates :measured_on, presence: true
end
