# frozen_string_literal: true

class Note < ApplicationRecord
  validates :content, presence: true

  belongs_to :notable, polymorphic: true
end
