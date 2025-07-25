class ApplicationController < ActionController::Base
  before_action :set_locale
  include SessionsHelper
  include Pagy::Backend

  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    unlogged_in_notification unless logged_in?
  end

  def unlogged_in_notification
    store_location
    flash[:danger] = t "users.error.unlogged_in"
    redirect_to login_url, status: :see_other
  end
end
