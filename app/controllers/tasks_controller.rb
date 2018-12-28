class TasksController < ApplicationController
  before_action :set_params, only: [:show, :edit, :update, :destroy]

  def index
    if params[:sort_expired]
      @tasks = Task.all.end_time_limit_sorted
    else
      @tasks = Task.all.created_at_sorted
    end
  end

  def new
    @task = Task.new
  end

  def create
    binding.pry
    @task = Task.new(task_params)
    binding.pry
    if @task.save
      binding.pry
      redirect_to task_path(@task.id), notice: "登録しました。"
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
      redirect_to tasks_path, notice: "編集しました。"
    else
      render "edit"
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "削除しました。"
  end

  private

  def set_params
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :status, "end_time_limit(1i)", "end_time_limit(2i)", "end_time_limit(3i)", "end_time_limit(4i)", "end_time_limit(5i)")
  end
end
