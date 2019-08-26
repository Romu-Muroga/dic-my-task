class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)#downcaseは値は更新しない。
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:success] = t("flash.login_success")
      redirect_to root_path
    else
      flash[:danger] = t("flash.login_miss")
      render "new"
    end
  end

  def destroy
    # session.delete(:user_id)
    reset_session
    flash[:success] = t("flash.logout")
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
