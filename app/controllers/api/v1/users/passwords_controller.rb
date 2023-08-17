class Api::V1::Users::PasswordsController < ApplicationController
  def forget
    return render json: { error: "email not present" } if params[:email].blank?
    user = User.find_by(email: params[:email])
    if user.present?
      user.generate_password_token!
      UserMailer.password_reset(user).deliver_now
      render json: { message: "Your reset token is send on your email" }, status: :ok
    else
      render json: { error: ["Email address not found. Please check and try again."] }, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s
    return render json: { error: "Token not present" } if params[:token].blank?
    return render json: { error: "Password not match" } if params[:password] != params[:confirm_password]
    byebug
    user = User.find_by(reset_password_token: token)
    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: { message: "your password is reset" }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: ["Link not valid or expired. Try generating a new link."] }, status: :not_found
    end
  end
end
