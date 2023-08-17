class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    
    if resource.persisted?
      render json: {
        message: "User created successfully",
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      }
    else
      render json: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" },
      status: :unauthorized
    end
  end
end
