class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user, :authenticate_user!, :set_current_user_time_zone
  helper_method :current_account

  private
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "public/401.html", :status => :unauthorized, :layout => false
  end

  def current_account
    @current_account ||= Account.find_current
  end

  def set_current_user
    Thread.current[:current_user] = current_user && current_user.id
  end

  def set_current_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end
end