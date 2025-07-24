class AccountActivationsController < ApplicationController
  before_action :get_user, only: :edit

  # GET /account_activations/:id/edit
  def edit
    if activate_for(@user)
      flash[:success] = t "mailer.account_activation.success"
      redirect_to @user
    else
      flash[:danger] = t "mailer.error.invalid_activation_link"
      redirect_to root_url, status: :see_other
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.error.user_not_found"
    redirect_to root_url, status: :see_other
  end

  def activate_for user
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      true
    else
      false
    end
  end
end
