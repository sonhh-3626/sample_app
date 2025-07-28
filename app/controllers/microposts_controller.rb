class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :load_user, only: %i(create destroy)
  before_action :correct_post, only: :destroy

  def create
    @micropost = @user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "microposts.success.created"
      redirect_to root_path
    else
      @pagy, @feed_items = pagy @user.microposts.order_by_latest, page: params[:page]
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.success.deleted"
    else
      flash[:danger] = t "microposts.error.delete_failed"
    end
    redirect_to root_path, status: :see_other
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def load_user
    @user = current_user
    return if @user.present?

    flash[:alert] = t "users.error.user_not_found"
    redirect_to root_path, status: :see_other
  end

  def correct_post
    @micropost = current_user.microposts.find_by id: params[:id]

    redirect_to root_path, status: :see_other if @micropost.nil?
  end
end
