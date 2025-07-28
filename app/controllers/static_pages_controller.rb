class StaticPagesController < ApplicationController
  def home
    @user = current_user
    return unless logged_in?

    @micropost = @user.microposts.build
    @pagy, @feed_items = pagy(
      @user.microposts.order_by_latest,
      page: params[:page]
    )
  end

  def help; end

  def about; end

  def contact; end
end
