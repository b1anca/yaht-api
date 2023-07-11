# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'Habit' do
  before do
    Rails.application.load_tasks
  end

  describe 'Rake Task habits:calculate_streaks' do
    let(:habit) { create(:habit) }

    before do
      create(:task, habit:, completed_at: 3.days.ago)
      create(:task, habit:, completed_at: 2.days.ago)
      create(:task, habit:, completed_at: 1.day.ago)
      Rake::Task['habits:calculate_streaks'].invoke
      habit.reload
    end

    it 'updates the streaks of existing habits' do
      expect(habit.current_streak).to eq(3)
      expect(habit.record_streak).to eq(3)
    end
  end
end
