# frozen_string_literal: true

class HabitSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :user_id, :created_at, :updated_at

  has_one :user
end
