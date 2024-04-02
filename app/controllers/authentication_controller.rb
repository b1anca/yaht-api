# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token:,
                     exp: JsonWebToken::EXPIRES_IN.from_now.strftime('%m-%d-%Y %H:%M'),
                     name: @user.name,
                     email: @user.email }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def logout
    session.destroy
    render json: { ok: 'unauthorized' }, status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
