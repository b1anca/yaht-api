# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/habits/2/tasks').to route_to('tasks#index', habit_id: '2')
    end

    it 'routes to #show' do
      expect(get: '/habits/2/tasks/1').to route_to('tasks#show', id: '1', habit_id: '2')
    end

    it 'routes to #create' do
      expect(post: '/habits/2/tasks').to route_to('tasks#create', habit_id: '2')
    end

    it 'routes to #update via PUT' do
      expect(put: '/habits/2/tasks/1').to route_to('tasks#update', id: '1', habit_id: '2')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/habits/2/tasks/1').to route_to('tasks#update', id: '1', habit_id: '2')
    end

    it 'routes to #destroy' do
      expect(delete: '/habits/2/tasks/1').to route_to('tasks#destroy', id: '1', habit_id: '2')
    end
  end
end
