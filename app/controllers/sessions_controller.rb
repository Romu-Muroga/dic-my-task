class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = t("flash.login_success")
      redirect_to root_path
    else
      flash[:danger] = t("flash.login_miss")
      render "new"
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:success] = t("flash.logout")
    redirect_to new_session_path
  end
end
