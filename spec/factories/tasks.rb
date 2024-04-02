# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    completed_at { '2024-04-02 17:42:43' }
    habit { nil }
  end
end
