# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Habit, type: :model do
  let(:habits) do
    [create(:habit, created_at: 10.days.ago),
     create(:habit, created_at: 5.days.ago)]
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '.update_progress' do
    before do
      create_list(:task, 5, habit: habits.first, completed_at: Time.zone.now)
      create_list(:task, 2, habit: habits.second, completed_at: Time.zone.now)
      habits.each(&:update_progress)
    end

    it 'updates overall_progress for each habit' do
      expect(habits.first.reload.overall_progress).to eq(50.0) # 5 out of 10 days
      expect(habits.second.reload.overall_progress).to eq(40.0) # 2 out of 5 days
    end
  end
end
