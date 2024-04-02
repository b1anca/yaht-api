# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/auth', type: :request do
  let!(:user) { create :user }

  describe 'POST /login' do
    let(:expected_response) do
      { token: String, exp: /\d{2}-\d{2}-\d{4} \d{2}:\d{2}$/, email: user.email, name: user.name }
    end

    it 'renders a successful response' do
      get auth_login_url, params: { email: user.email, password: 'password123' }, as: :json
      expect(response).to be_ok
      expect(response.body).to match_json_expression(expected_response)
    end
  end
end
