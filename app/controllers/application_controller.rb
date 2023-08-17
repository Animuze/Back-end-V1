class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  def pundit_user
    current_admin
  end

  rescue_from Pundit::NotAuthorizedError, with: :invalid_access
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |e| e.permit(:email, :password, :password_confirmation  )}
    devise_parameter_sanitizer.permit(:account_update) { |e| e.permit( :email, :password, :password_confirmation)}
  end

  protected

  def invalid_access
    flash[:alert] = "You are not authorized for this action"
    redirect_to(request.referrer || root_path)
  end
end
