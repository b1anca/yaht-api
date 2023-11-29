# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateProgressJob, type: :job do
  describe '#perform' do
    let!(:habit1) { create(:habit) }
    let!(:habit2) { create(:habit) }

    before do
      allow(Habit).to receive(:find_each).and_yield(habit1).and_yield(habit2)
      allow(habit1).to receive(:update_progress)
      allow(habit1).to receive(:update_streaks)
      allow(habit2).to receive(:update_progress)
      allow(habit2).to receive(:update_streaks)

      described_class.perform_now
    end

    it 'calls update_progress and update_streaks on all habits' do
      expect(habit1).to have_received(:update_progress)
      expect(habit1).to have_received(:update_streaks)
      expect(habit2).to have_received(:update_progress)
      expect(habit2).to have_received(:update_streaks)
    end
  end
end
