# frozen_string_literal: true

module RequestHelpers
  def auth_headers(user)
    { 'Authorization': "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
  end

  def result
    JSON.parse(response.body)
  end
end
