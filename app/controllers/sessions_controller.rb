class SessionsController < ApplicationController
  before_action :find_user_by_email, only: :create

  def new; end

  def create
    if @user&.authenticate params.dig(:session, :password)
      forwarding_url = session[:forwarding_url]
      reset_session
      handle_remember_me_for @user
      log_in @user
      redirect_to forwarding_url || @user
      flash[:success] = t "session.login.success"
    else
      flash.now[:danger] = t "session.login.invalid"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    forget current_user if current_user
    redirect_to root_url, status: :see_other
  end

  private

  def find_user_by_email
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t("users.error.invalid_email")
    render :new, status: :unprocessable_entity
  end

  def handle_remember_me_for user
    if params.dig(:session, :remember_me) == Settings.remember_me_enabled
      remember user
    else
      forget user
    end
  end
end
