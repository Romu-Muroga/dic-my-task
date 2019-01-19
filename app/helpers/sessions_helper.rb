module SessionsHelper
  # 以下のメソッドをapplication_controller.rbに直接書くと、コントローラでは使えるけどviewファイルでは使えない。
  # undefined method `logged_in?' for...エラーになってしまう。
  # Railsの初期設定では、全てのhelperが全てのViewから読み込める。helperは初期設定ではViewを対象に作成されている。
  def current_user
    @current_user || @current_user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end
end
