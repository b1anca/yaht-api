# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/tasks', type: :request do
  let(:user) { create :user }
  let!(:task) { create :task, habit: create(:habit, user:) }
  let(:valid_attributes) do
    { completed_at: '2023-05-09 03:25:24' }
  end

  let(:invalid_attributes) do
    { completed_at: nil }
  end

  let(:valid_headers) do
    auth_headers(user)
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get habit_tasks_url(habit_id: task.habit_id), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get habit_task_url(habit_id: task.habit_id, id: task.id), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Task' do
        expect do
          post habit_tasks_url(habit_id: task.habit_id),
               params: valid_attributes, headers: valid_headers, as: :json
        end.to change(Task, :count).by(1)
      end

      it 'renders a JSON response with the new task' do
        post habit_tasks_url(habit_id: task.habit_id),
             params: valid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Task' do
        expect do
          post habit_tasks_url(habit_id: task.habit_id),
               params: invalid_attributes, as: :json
        end.to change(Task, :count).by(0)
      end

      it 'renders a JSON response with errors for the new task' do
        post habit_tasks_url(habit_id: task.habit_id),
             params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { completed_at: '2023-06-10 03:25:24' }
      end

      it 'updates the requested task' do
        patch habit_task_url(habit_id: task.habit_id, id: task.id),
              params: new_attributes, headers: valid_headers, as: :json
        task.reload
        expect(task.completed_at.to_datetime).to eq(new_attributes[:completed_at].to_datetime)
      end

      it 'renders a JSON response with the task' do
        patch habit_task_url(habit_id: task.habit_id, id: task.id),
              params: new_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the task' do
        patch habit_task_url(habit_id: task.habit_id, id: task.id),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested task' do
      expect do
        delete habit_task_url(habit_id: task.habit_id, id: task.id), headers: valid_headers, as: :json
      end.to change(Task, :count).by(-1)
    end
  end
end
