class UsersController < ApplicationController
  before_action :logged_in_user,
                only: %i(index edit update destroy following followers)
  before_action :load_user,
                only: %i(show edit update destroy following followers)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :check_user_activated?, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "mailer.account_activation.check_email"
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pagy, @microposts = pagy(
      @user.microposts,
      limit: Settings.items_per_page_20
    )
  end

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

  def following
    @title = t "users.show.title_following"
    @pagy, @users = pagy(
      current_user.following,
      limit: Settings.items_per_page_20
    )
    render "show_follow", status: :unprocessable_entity
  end

  def followers
    @title = t "users.show.title_followers"
    @pagy, @users = pagy current_user.followers, limit: Settings.items_per_page_20
    render "show_follow", status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit User::PERMITTED_ATTRIBUTES
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:alert] = t "users.error.user_not_found"
    redirect_to root_path, status: :see_other
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

  def check_user_activated?
    redirect_to root_url and return unless @user.activated?
  end
end
