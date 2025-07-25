class StaticPagesController < ApplicationController
  def home
    @user = current_user
    return unless logged_in?

    @micropost = @user.microposts.build
    @pagy, @feed_items = pagy @user.feed, page: params[:page]
  end

  def help; end

  def about; end

  def contact; end
end
