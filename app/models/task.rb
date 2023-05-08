# frozen_string_literal: true

class Task < ApplicationRecord
  validates :completed_at, presence: true

  belongs_to :habit
end
