class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index show edit update destroy)
  before_action :load_user, only: %i(show edit update)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.page(params[:page]).per(Settings.per_page).sort_by_new
  end

  def new
    @user = User.new
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t :update_success
      redirect_to @user
    else
      render :edit
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by id: params[:id]
    if @user.update! user_params
      flash[:success] = t :update_success
      redirect_to @user
    else
      render :new
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t :message_activate
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t :success_update
    else
      flash[:danger] = t :error_update
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t :not_found
    redirect_to new_user_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t :sign_in
    redirect_to login_path
  end

  def correct_user
    redirect_to(login_path) unless current_user?(@user)
  end
end
