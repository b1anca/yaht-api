# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/auth', type: :request do
  let!(:user) { create :user }

  describe 'POST /login' do
    it 'renders a successful response' do
      get auth_login_url, params: { email: user.email, password: 'password123' }, as: :json
      expect(response).to be_ok
      # expect(result).to eq(token: 1)
    end
  end
end
