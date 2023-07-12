# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HabitSerializer do
  let(:habit) { create(:habit, :with_tasks) }
  let(:serializer) { described_class.new(habit) }
  let!(:json) { serializer.to_json }
  let(:pattern) do
    { id: Numeric,
      name: String,
      user_id: Numeric,
      created_at: String,
      updated_at: String,
      color: wildcard_matcher,
      description: wildcard_matcher,
      overall_progress: '100.0',
      current_streak: 3,
      record_streak: 3,
      tasks: [{ habit_id: habit.id }.ignore_extra_keys!,
              { habit_id: habit.id }.ignore_extra_keys!,
              { habit_id: habit.id }.ignore_extra_keys!] }
  end

  it 'has all the expected attributes' do
    expect(json).to match_json_expression(pattern)
  end
end
