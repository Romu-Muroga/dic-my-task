class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: "登録しました。"
    else
      render "new"
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.save
      redirect_to tasks_path, notice: "編集しました。"
    else
      render "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
