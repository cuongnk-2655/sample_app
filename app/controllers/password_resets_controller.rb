class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new
  end

  def edit; end

  def update
    if @user.update user_params
      log_in @user
      redirect_to @user
    else
      render :edit
    end
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t :send_mail_reset_pass
      redirect_to @user
    else
      flash.now[:danger] = t :not_found
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email].downcase
    return if @user

    flash.now[:danger] = t :not_found
    render :new
  end

  def valid_user
    return if @user&.authenticated?(:reset, params[:id]) && @user.activated
    redirect_to "/"
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t :password_reset_expired
    redirect_to new_password_reset_url
  end
end
