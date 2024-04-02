# frozen_string_literal: true

class TaskSerializer < ActiveModel::Serializer
  attributes :id, :completed_at
  has_one :habit
end
