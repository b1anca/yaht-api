# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/notes', type: :request do
  let(:user) { create :user }
  let(:habit) { create :habit, user: }
  let(:valid_attributes) do
    { content: 'some content' }
  end
  let(:invalid_attributes) do
    { content: nil }
  end
  let(:valid_headers) do
    auth_headers(user)
  end

  describe 'GET /index' do
    context 'with invalid headers' do
      it 'renders an unauthorized response' do
        get habit_notes_url(habit), headers: {}, as: :json
        expect(response).to be_unauthorized
      end
    end

    context 'with valid headers' do
      before do
        create :note, content: 'Habit note', notable: habit
        create :note, content: 'User note', notable: user
      end

      it 'renders a successful response' do
        get habit_notes_url(habit), headers: valid_headers, as: :json
        expect(response).to be_successful
      end

      it 'only returns the notes for the habit' do
        get habit_notes_url(habit), headers: valid_headers, as: :json
        expect(response.body).to match_json_expression([{ content: 'Habit note' }.ignore_extra_keys!])
      end

      it 'only returns the notes for the user' do
        get user_notes_url(user), headers: valid_headers, as: :json
        expect(response.body).to match_json_expression([{ content: 'User note' }.ignore_extra_keys!])
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Note' do
        expect do
          post habit_notes_url(habit_id: habit.id),
               params: valid_attributes, headers: valid_headers, as: :json
        end.to change(Note, :count).by(1)
      end

      it 'renders a JSON response with the new note' do
        post habit_notes_url(habit_id: habit.id),
             params: valid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new note' do
        expect do
          post habit_notes_url(habit_id: habit.id),
               params: invalid_attributes, as: :json
        end.to change(Note, :count).by(0)
      end

      it 'renders a JSON response with errors for the new note' do
        post habit_notes_url(habit_id: habit.id),
             params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end
end
