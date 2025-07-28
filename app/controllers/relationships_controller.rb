class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :set_user_for_following, only: :create
  before_action :set_relationship, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user, status: :see_other}
      format.turbo_stream
    end
  end

  private

  def set_user_for_following
    @user = User.find_by id: params.dig(:relationship, :followed_id)
    return if @user

    flash[:error] = t "microposts.errors.user_not_found"
    redirect_to root_url
  end

  def set_relationship
    @relationship = Relationship.find params[:id]
    return @relationship if @relationship

    flash[:error] = t "microposts.errors.relationship_not_found"
    redirect_to root_url
  end
end
