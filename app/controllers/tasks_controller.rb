class TasksController < ApplicationController
  before_action :set_params, only: [:show, :edit, :update, :destroy]

  def index
    if params[:etl_sort]
      @tasks = Task.end_time_limit_sorted.limit(30)#all省略
    elsif params[:pri_sort]
      @tasks = Task.priority_sorted.limit(30)#all省略
    else
      @tasks = Task.created_at_sorted.limit(30)#all省略
    end
  end

  def search
    # present?を書かないとフィールドが空欄（""）でも検索しにいってしまいエラーが起こる？
    if params[:task][:title].present? && params[:task][:status].present?
      @tasks = Task.title_status_search(params[:task][:title], params[:task][:status])
      render "index"
    elsif params[:task][:title].present?
      @tasks = Task.title_search(params[:task][:title])
      render "index"
    elsif params[:task][:status].present?
      @tasks = Task.status_search(params[:task][:status])
      render "index"
    elsif params[:task][:title].blank? && params[:task][:status].blank?
      redirect_to tasks_path, notice: t("flash.blank")
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task.id), notice: t("flash.create")
    else
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t("flash.update")
    else
      render "edit"
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t("flash.destroy")
  end

  private

  def set_params
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :status, :priority,
                                 "end_time_limit(1i)", "end_time_limit(2i)", "end_time_limit(3i)", "end_time_limit(4i)", "end_time_limit(5i)")
  end
end
