class Admin::LabelsController < ApplicationController
  before_action :current_user_admin?
  before_action :set_params, only: [:edit, :update, :destroy]

  def index
    @labels = Label.all
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:success] = t("flash.create")
      redirect_to admin_labels_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      flash[:success] = t("flash.update")
      redirect_to admin_labels_path
    else
      render "edit"
    end
  end

  def destroy
    @label.destroy
    flash[:success] = t("flash.destroy")
    redirect_to admin_labels_path
  end

  private

  # 管理者権限を持つユーザーではなかったらルートパスへ移動
  def current_user_admin?
    return if current_user.admin?
    
    flash[:danger] = t("flash.admin_alert")
    redirect_to root_path
  end

  def set_params
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
