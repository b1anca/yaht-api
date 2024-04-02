# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/habits', type: :request do
  let(:user) { create :user }
  let!(:habit) { create :habit, user: }
  let(:valid_attributes) do
    { name: Faker::Sport.sport }
  end
  let(:invalid_attributes) do
    { name: nil }
  end
  let(:valid_headers) do
    auth_headers(user)
  end

  describe 'GET /index' do
    context 'with invalid headers' do
      it 'renders an unauthorized response' do
        get habits_url, headers: {}, as: :json
        expect(response).to be_unauthorized
      end
    end

    context 'with valid headers' do
      it 'renders a successful response' do
        get habits_url, headers: valid_headers, as: :json
        expect(response).to be_successful
      end

      it 'only returns the habits from the current_user' do
        get habits_url, headers: valid_headers, as: :json
        expect(response.body).to match_json_expression([{ user_id: user.id }.ignore_extra_keys!])
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get habit_url(habit), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Habit' do
        expect do
          post habits_url,
               params: valid_attributes, headers: valid_headers, as: :json
        end.to change(Habit, :count).by(1)
      end

      it 'renders a JSON response with the new habit' do
        post habits_url,
             params: valid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Habit' do
        expect do
          post habits_url,
               params: invalid_attributes, as: :json
        end.to change(Habit, :count).by(0)
      end

      it 'renders a JSON response with errors for the new habit' do
        post habits_url,
             params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'Updated name', color: '#2978e6', description: 'new description' }
      end

      it 'updates the requested habit' do
        expect do
          patch habit_url(habit), params: new_attributes, headers: valid_headers, as: :json
          habit.reload
        end.to change(habit, :name).to('Updated name')
                                   .and change(habit, :color).to('#2978e6')
                                   .and change(habit, :description).to('new description')
      end

      it 'renders a JSON response with the habit' do
        patch habit_url(habit),
              params: new_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the habit' do
        patch habit_url(habit),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested habit' do
      expect do
        delete habit_url(habit), headers: valid_headers, as: :json
      end.to change(Habit, :count).by(-1)
    end
  end
end
