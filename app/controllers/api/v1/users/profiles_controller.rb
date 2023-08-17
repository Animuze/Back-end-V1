class Api::V1::Users::ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:update_profile]

  def update_profile
    @profile = current_user
    if @profile.update(user_params)
      render json: {
        message: "update successfully",
        data: UserSerializer.new(@profile).serializable_hash[:data][:attributes],
      }, status: :ok
    else
      render json: {
        message: "could not updated, #{@profile.errors.full_messages.to_sentence}",
      }, status: :unauthorized
    end
  end

  def google_sign_in
    @user = User.signin_or_create_from_provider(social_media_params) # this method add a user who is new or logins an old one
    if @user.persisted?
      sign_in(@user)
      render json: {
        status: 'SUCCESS',
        message: "user was successfully logged in through #{params[:provider]}",
        data: UserSerializer.new(@user).serializable_hash[:data][:attributes],
        },status: :created
    else
      render json: {
        status: 'FAILURE',
        message: "There was a problem signing you in through #{params[:provider]}",
        data: @user.errors,
        },status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
  
  def social_media_params
    params.require(:profile).permit(:uid, :provider, :id_token, info: [:email, :name ])
  end
end
