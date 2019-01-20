class Admin::UsersController < ApplicationController
  # before_action :login_check, only: [:new]
  # before_action :current_user_check, only: [:show]
  before_action :current_user_admin?
  before_action :set_user, only: [:edit, :update, :show, :destroy]

  def index
    @users = User.select(:id, :name, :email, :created_at, :updated_at, :admin).includes(:tasks)# N+1問題を回避
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # セーブできたら同時にログイン
      # session[:user_id] = @user.id
      # flash[:success] = t("flash.sign_up_and_login")
      flash[:success] = t("flash.sign_up")
      redirect_to admin_user_path(@user.id)
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = t("flash.update")
      redirect_to admin_users_path
    else
      flash[:danger] = t("flash.admin_loss") if @user.admin_users_last?
      render "edit"
    end
  end

  def show
  end

  def destroy
    if @user.destroy
      flash[:success] = t("flash.user_destroy", user: @user.name)
      redirect_to admin_users_path
    else
      flash[:danger] = t("flash.admin_loss")
      redirect_to admin_users_path
    end
  end

  private

  # # ログインしている状態でサインアップ画面に遷移できないようにする
  # def login_check
  #   if logged_in?
  #     flash[:danger] = t("flash.sign_up_info")
  #     redirect_to user_path(current_user.id)
  #   end
  # end
  #
  # # 他人のマイページに遷移できないようにする
  # def current_user_check
  #   unless params[:id].to_i == current_user.id
  #     flash[:danger] = t("flash.my_page_info", user: current_user.name)
  #     redirect_to user_path(current_user.id)
  #   end
  # end

  # 管理者権限を持つユーザーではなかったらルートパスへ移動
  def current_user_admin?
    unless logged_in? && current_user.admin?
      flash[:danger] = t("flash.admin_alert")
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end
end
