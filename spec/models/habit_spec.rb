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

    context 'when tasks are completed on consecutive days' do
      before do
        create(:task, habit:, completed_at: 2.days.ago)
        create(:task, habit:, completed_at: 1.day.ago)
      end

      it 'updates the current streak and record streak' do
        expect(habit.current_streak).to eq(2)
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
        create(:task, habit:, completed_at: 3.days.ago)
        create(:task, habit:, completed_at: 2.days.ago)
        create(:task, habit:, completed_at: 1.day.ago)
        create(:task, habit:, completed_at: Time.current)
      end

      it 'updates the record streak' do
        expect(habit.current_streak).to eq(4)
        expect(habit.record_streak).to eq(4)
      end
    end
  end
end
