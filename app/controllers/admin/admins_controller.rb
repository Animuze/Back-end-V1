class Admin::AdminsController < ApplicationController
  before_action :set_admin_user, only: [:edit, :update, :destroy]
  before_action :authenticate_admin!

  def index
    authorize ([:admin, :admin])
    @admin_users = Admin.all
  end

  def destroy
    authorize ([:admin, :admin])
    @admin_user.destroy
    respond_to do |format|
      format.html { redirect_to admin_admins_path, notice: 'Admin user Deleted Successfully' }
      format.json { head :no_content }
    end
  end

  def new
    authorize ([:admin, :admin])
    @admin_user = Admin.new
  end

  def edit
    authorize ([:admin, :admin])
  end

  def update
    authorize ([:admin, :admin])
    respond_to do |format|
      if @admin_user.update(admin_user_params)
        format.html { redirect_to admin_admins_path, notice: 'Admin user Updated Successfully ' }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    authorize ([:admin, :admin])
    @admin_user = Admin.new(admin_user_params)
    generated_password = Devise.friendly_token.first(8)
    @admin_user.password = generated_password

    respond_to do |format|
      if @admin_user.save
        AdminMailer.new_user_password(@admin_user.id, generated_password).deliver
        format.html { redirect_to admin_admins_path, notice: 'Admin User Added Successfully ' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def set_admin_user
    @admin_user = Admin.find(params[:id])
  end

  def admin_user_params
    params.require(:admin).permit(:email, {role_ids: []})
  end
end
