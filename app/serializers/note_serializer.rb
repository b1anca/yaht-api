# frozen_string_literal: true

class NoteSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at
end
