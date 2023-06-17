# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Habit, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '.update_progress' do
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
      habits.each(&:update_progress)
    end

    it 'updates overall_progress for each habit' do
      expect(habits.first.reload.overall_progress).to eq(50.0)
      expect(habits.second.reload.overall_progress).to eq(50.0)
    end
  end
end
