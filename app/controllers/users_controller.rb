class UsersController < ApplicationController
  before_action :login_check, only: [:new]
  before_action :current_user_check, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # セーブできたら同時にログイン
      session[:user_id] = @user.id
      flash[:success] = t("flash.sign_up_and_login")
      redirect_to user_path(@user.id)
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def login_check
    if logged_in?
      flash[:info] = t("flash.sign_up_info")
      redirect_to user_path(current_user.id)
    end
  end

  def current_user_check
    unless params[:id].to_i == current_user.id
      flash[:info] = t("flash.my_page_info", user: current_user.name)
      redirect_to user_path(current_user.id)
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
