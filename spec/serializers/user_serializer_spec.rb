# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }
  let!(:json) { serializer.to_json }
  let(:pattern) do
    { id: Numeric,
      name: String,
      email: String,
      created_at: String,
      updated_at: String }
  end

  it 'has all the expected attributes' do
    expect(json).to match_json_expression(pattern)
  end
end
