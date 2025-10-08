class ApplicationController < ActionController::Base
  include Authentication

  before_action :resume_session
  before_action :require_authentication

  private
  def after_authentication_url = root_path

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticated?
    current_user.present?
  end

  def require_authentication
    return if authenticated?
    redirect_to new_session_path, alert: "Please log in first", status: :see_other
  end
end
