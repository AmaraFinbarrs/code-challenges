# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opt = {})
    @token = request.env["warden-jwt_auth.token"]
    headers["Authorization"] = @token

    render json: {
      status: {
        code: 200, message: "Logged in successfully.",
        token: @token,
        data: {
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }
    }, status: :ok
  end

  def respond_to_on_destroy(*_args)
    current_user = nil

    if request.headers["Authorization"].present?
      begin
        # Extract token from "Bearer <token>" format
        token = request.headers["Authorization"].split.last
        secret = Rails.application.credentials.devise_jwt_secret_key!

        # Securely decode by forcing verification and algorithm type
        jwt_payload = JWT.decode(token, secret, true, { algorithm: "HS256" }).first

        current_user = User.find_by(id: jwt_payload["sub"])
      rescue JWT::DecodeError, JWT::ExpiredSignature
        # Catches expired or tampered tokens safely
        current_user = nil
      end
    end

    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
