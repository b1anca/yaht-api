# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    completed_at { '2023-05-08 03:25:24' }
    habit { nil }
  end
end
