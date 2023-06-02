# frozen_string_literal: true

class HabitSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :created_at, :updated_at, :tasks
end
