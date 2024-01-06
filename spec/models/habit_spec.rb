# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Habit, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#update_progress' do
    let(:habits) do
      [create(:habit, created_at: 11.days.ago),
       create(:habit)]
    end

    before do
      6.times do |i|
        create(:task, habit: habits.first, completed_at: Time.zone.today - i)
      end
      6.times do |i|
        create(:task, habit: habits.second, completed_at: 11.days.ago + i)
      end
    end

    it 'updates overall_progress for each habit' do
      expect(habits.first.reload.overall_progress).to eq(50.0)
      expect(habits.second.reload.overall_progress).to eq(50.0)
    end
  end

  describe '#update_streaks' do
    let(:habit) { create(:habit) }

    context 'when considering user timezone for streak calculations' do
      before do
        habit.user.update!(time_zone: 'Eastern Time (US & Canada)')
        # 2024-01-01 23:00:00 UTC - 2024-01-01 18:00:00 EST
        travel_to Time.find_zone('UTC').local(2024, 1, 1, 23, 0, 0) do
          create(:task, habit:, completed_at: Time.current)
          habit.update_streaks
        end
      end

      it 'does not prematurely reset the current streak when it’s still the same day in the user’s timezone' do
        # 2024-01-02 02:00:00 UTC - 2024-01-01 21:00:00 EST
        travel_to Time.find_zone('UTC').local(2024, 1, 2, 2, 0, 0) do
          habit.update_streaks
        end

        expect(habit.current_streak).to eq(1)
      end

      it 'resets the current streak to zero after the day changes in the user’s timezone without a new task' do
        # 2024-01-02 06:00:00 UTC - 2024-01-02 01:00:00 EST
        travel_to Time.find_zone('UTC').local(2024, 1, 2, 6, 0, 0) do
          habit.update_streaks
        end

        expect(habit.current_streak).to eq(0)
      end
    end

    context 'when tasks are completed on consecutive days including today' do
      before do
        create(:task, habit:, completed_at: 1.day.ago)
        create(:task, habit:, completed_at: Time.current)
      end

      it 'updates the current streak and record streak' do
        expect(habit.current_streak).to eq(2)
        expect(habit.record_streak).to eq(2)
      end
    end

    context 'when tasks are completed on consecutive days but not today' do
      before do
        (1..2).each { |i| create(:task, habit:, completed_at: i.days.ago) }
      end

      it 'updates the current streak and record streak' do
        expect(habit.current_streak).to eq(0)
        expect(habit.record_streak).to eq(2)
      end
    end

    context 'when tasks are not completed on consecutive days' do
      before do
        create(:task, habit:, completed_at: 2.days.ago)
        create(:task, habit:, completed_at: Time.current)
      end

      it 'resets the current streak and maintains the record streak' do
        expect(habit.current_streak).to eq(1)
        expect(habit.record_streak).to eq(1)
      end
    end

    context 'when a record streak is surpassed' do
      before do
        (6..7).each { |i| create(:task, habit:, completed_at: i.days.ago) }
      end

      it 'updates the record streak' do
        expect(habit.record_streak).to eq(2)
        (1..4).each { |i| create(:task, habit:, completed_at: i.days.ago) }
        expect(habit.record_streak).to eq(4)
      end
    end
  end
end
