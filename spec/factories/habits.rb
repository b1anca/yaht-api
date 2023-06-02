# frozen_string_literal: true

FactoryBot.define do
  factory :habit do
    name { Faker::Sport.sport }
    user { create(:user) }

    trait :with_tasks do
      after(:create) do |habit|
        3.times do |i|
          create(:task, habit:, completed_at: i.days.ago)
        end
      end
    end
  end
end
