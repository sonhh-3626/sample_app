class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "common.welcome"
      reset_session
      log_in @user
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def index
    @pagy, @users = pagy User.order_by_name, limit: Settings.items_per_page_20
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.success.updated"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.success.deleted"
    else
      flash[:danger] = t "users.error.delete_failed"
    end
    redirect_to users_url, status: :see_other
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:alert] = t "users.error.user_not_found"
    redirect_to root_path, status: :see_other
  end

  def user_params
    params.require(:user).permit User::PERMITTED_ATTRIBUTES
  end

  def logged_in_user
    unlogged_in_notification unless logged_in?
  end

  def unlogged_in_notification
    store_location
    flash[:danger] = t "users.error.unlogged_in"
    redirect_to login_url, status: :see_other
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if current_user? @user

    flash[:danger] = t "users.error.not_correct_user"
    redirect_to root_url, status: :see_other
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "users.error.not_admin"
    redirect_to root_url, status: :see_other
  end
end
