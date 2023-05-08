# frozen_string_literal: true

FactoryBot.define do
  factory :habit do
    name { Faker::Sport.sport }
    user { nil }
  end
end
