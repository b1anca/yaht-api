# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  let!(:user) { create :user }
  let(:valid_attributes) do
    { name: Faker::Name.name, email: Faker::Internet.email, password: 'password123',
      password_confirmation: 'password123' }
  end
  let(:invalid_attributes) do
    { name: nil }
  end
  let(:valid_headers) do
    auth_headers(user)
  end

  describe 'GET /index' do
    context 'with invalid headers' do
      it 'renders a successful response' do
        get users_url, headers: {}, as: :json
        expect(response).to be_unauthorized
      end
    end

    context 'with valid headers' do
      it 'renders a successful response' do
        get users_url, headers: valid_headers, as: :json
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get user_url(user), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /me' do
    it 'renders a successful response' do
      get me_users_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url,
               params: valid_attributes, headers: {}, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post users_url,
             params: valid_attributes, headers: {}, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url,
               params: invalid_attributes, as: :json
        end.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new user' do
        post users_url,
             params: invalid_attributes, headers: {}, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'Tester updated' }
      end

      it 'updates the requested user' do
        patch user_url(user),
              params: new_attributes, headers: valid_headers, as: :json
        user.reload
        expect(user.name).to eq('Tester updated')
      end

      it 'renders a JSON response with the user' do
        patch user_url(user),
              params: new_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the user' do
        patch user_url(user),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      expect do
        delete user_url(user), headers: valid_headers, as: :json
      end.to change(User, :count).by(-1)
    end
  end
end
