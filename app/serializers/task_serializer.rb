# frozen_string_literal: true

class TaskSerializer < ActiveModel::Serializer
  attributes :id, :completed_at, :habit_id, :created_at, :updated_at
end
