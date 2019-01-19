class ApplicationController < ActionController::Base
  # 全コントローラでSessionsHelperモジュールを使用するための記述
  include SessionsHelper
  # basic認証をproduction環境にのみ設定
  before_action :basic if Rails.env == "production"

  private

  def basic
    authenticate_or_request_with_http_basic do |name, password|
      name == ENV['BASIC_AUTH_NAME'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
