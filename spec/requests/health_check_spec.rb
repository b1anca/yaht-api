# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HealthChecks', type: :request do
  describe 'GET /show' do
    it 'renders a successful response' do
      get up_url, as: :json
      expect(response).to be_successful
    end
  end
end
