class AuthsController < ApplicationController
  before_action :load_user, only: %i(create)

  def new; end

  def create
    if @user.activated && @user.authenticate(params[:auth][:password])
      log_in @user
      params[:auth][:remember_me] == Settings.remember ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t :account_not_activate
      redirect_to root_path
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private
  def load_user
    @user = User.find_by email: params[:auth][:email].downcase
    return if @user

    flash.now[:danger] = t :invalid_email_password_combination
    render :new
  end
end
