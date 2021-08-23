class AccountActivationsController < ApplicationController
  before_action :load_user, only: %i(edit)

  def edit
    if !@user.activated && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t :activated
      redirect_to @user
    else
      flash[:danger] = t :invalid_link
      redirect_to users_path
    end
  end

  private
  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t :not_found
    redirect_to new_user_path
  end
end
