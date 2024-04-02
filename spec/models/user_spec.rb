# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_length_of(:password).is_at_least(10) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('Eastern Time (US & Canada)').for(:time_zone) }
    it { is_expected.not_to allow_value('Invalid Time Zone').for(:time_zone) }
    it { is_expected.to allow_value(nil).for(:time_zone) }
  end

  describe 'password encryption' do
    it 'encrypts the password' do
      expect(user.password_digest).not_to eq 'password123'
    end
  end

  describe 'email format validation' do
    let(:user_with_invalid_email) { FactoryBot.build(:user, email: 'invalid-email') }

    it 'allows valid email addresses' do
      expect(user).to be_valid
    end

    it 'does not allow invalid email addresses' do
      expect(user_with_invalid_email).not_to be_valid
    end
  end
end
