# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    content { 'note content' }
    association :notable, factory: :habit
  end
end
