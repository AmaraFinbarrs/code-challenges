# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    # 1. Handle successful deletion (Destroy)
    if request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully." }
      }, status: :ok

    # 2. Handle successful registration (Create)
    elsif resource.persisted?
      @token = request.env["warden-jwt_auth.token"]
      headers["Authorization"] = @token

      render json: {
        status: { code: 200, message: "Signed up successfully.",
                  token: @token,
                  data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }

    # 3. Handle failed registration or failed deletion
    else
      render json: {
        status: { message: "Request failed. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
