# frozen_string_literal: true

class HealthCheckController < ApplicationController
  skip_before_action :authenticate_request

  rescue_from(Exception) { render head: 503 }

  def show
    render head: 200
  end
end
