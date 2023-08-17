class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.valid?
      render json: {
        message: "Logged in successfully.",
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      }, status: :ok
    else
      render json: {
        message: "email or password is invalid",
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        message: "logged out successfully",
      }, status: :ok
    else
      render json: {
        message: "Couldn't find an active session.",
      }, status: :unauthorized
    end
  end
end
