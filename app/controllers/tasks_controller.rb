# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def index
    @tasks = Habit.find(params[:habit_id]).tasks

    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created, location: habit_task_url(habit_id: @task.habit_id, id: @task.id)
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def set_task
    @task = Habit.find(params[:habit_id]).tasks.find(params[:id])
  end

  def task_params
    params.permit(:completed_at, :habit_id)
  end
end
