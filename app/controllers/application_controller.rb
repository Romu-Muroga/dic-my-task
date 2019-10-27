class ApplicationController < ActionController::Base
  # basic認証をproduction環境にのみ設定
  before_action :basic if Rails.env == "production"
  before_action :login_check
  helper_method :current_user, :logged_in?

  private

  def basic
    authenticate_or_request_with_http_basic do |name, password|
      name == ENV['BASIC_AUTH_NAME'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def login_check
    return if logged_in?

    flash[:danger] = t("flash.login_info")
    redirect_to login_path
  end
end
