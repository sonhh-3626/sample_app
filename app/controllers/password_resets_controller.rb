class PasswordResetsController < ApplicationController
  before_action :get_user, only: :create
  before_action :get_user_by_email, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email

    flash[:info] = t "session.forgot_password.email_sent"
    redirect_to root_url
  end

  def edit; end

  def update
    if params.dig(:user, :password).empty?
      @user.errors.add :password, t("mailer.password_reset.error.pw_empty")
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params)
      @user.forget
      reset_session
      log_in @user
      flash[:success] = t "mailer.password_reset.success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit User::RESET_PW_PERMITTED_ATTRIBUTES
  end

  def get_user
    @user = User.find_by email: params.dig(:password_reset, :email).downcase
    return if @user

    handle_not_found_user
  end

  def get_user_by_email
    @user = User.find_by email: params[:email].downcase
    return if @user

    handle_not_found_user
  end

  def handle_not_found_user
    flash.now[:danger] = t "mailer.password_reset.error.email_not_found"
    render :new, status: :unprocessable_entity
  end

  def valid_user
    return if @user&.activated? &&
              @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash.now[:danger] = t "mailer.password_reset.error.pw_reset_has_expired"
    redirect_to new_password_reset_url
  end
end
