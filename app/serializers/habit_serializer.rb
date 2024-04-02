# frozen_string_literal: true

class HabitSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :description, :user_id, :overall_progress, :created_at,
             :updated_at, :record_streak, :current_streak, :tasks
end
