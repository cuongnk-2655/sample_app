class AuthsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:auth][:email].downcase
    if user&.authenticate params[:auth][:password]
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t :invalid_email_password_combination
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
