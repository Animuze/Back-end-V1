class AdminMailer < ApplicationMailer
  def new_user_password(id, generated_password)
    @admin_user = Admin.find(id)
    @generated_password = generated_password
    mail to: @admin_user.email, subject: "Your Login Credentials"
  end
end
