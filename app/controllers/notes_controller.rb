# frozen_string_literal: true

class NotesController < ApplicationController
  def index
    @notes = if params[:habit_id].present?
               current_user.habits.find(params[:habit_id]).notes
             else
               current_user.notes
             end

    render json: @notes
  end

  def create
    notable = params[:habit_id] ? current_user.habits.find(params[:habit_id]) : current_user
    @note = Note.new(note_params.merge(notable:))

    if @note.save
      render json: @note, status: :created
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def note_params
    params.permit(:content)
  end
end
