# frozen_string_literal: true

class HabitsController < ApplicationController
  before_action :set_habit, only: %i[show update destroy]

  def index
    @habits = current_user.habits.includes(:tasks)

    render json: @habits
  end

  def show
    render json: @habit
  end

  def create
    @habit = current_user.habits.new(habit_params)

    if @habit.save
      render json: @habit, status: :created, location: @habit
    else
      render json: { errors: @habit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @habit.update(habit_params)
      render json: @habit
    else
      render json: { errors: @habit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @habit.destroy
  end

  private

  def set_habit
    @habit = current_user.habits.includes(:tasks).find(params[:id])
  end

  def habit_params
    params.permit(:name, :color, :description, :user_id)
  end
end
