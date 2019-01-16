class TasksController < ApplicationController
  before_action :set_params, only: [:show, :edit, :update, :destroy]
  before_action :login_check
  PER = 8

  def index
    if params[:etl_sort]
      @tasks = current_user.tasks.page(params[:page]).per(PER).end_time_limit_sorted#all省略
    elsif params[:pri_sort]
      @tasks = current_user.tasks.page(params[:page]).per(PER).priority_sorted#all省略
    else
      @tasks = current_user.tasks.page(params[:page]).per(PER).created_at_sorted#all省略
    end
  end

  # # indexアクション内で検索するとき
  # def index
  #   # 「if文中のnilはfalseとして扱われる」if文中で、falseと同等の値として扱われるのはnilだけ。
  #   # falseとnil以外の値、たとえば、0、[],””などはtrueとして扱われる。
  #   if params[:etl_sort]#返り値がnil
  #     @tasks = Task.page(params[:page]).per(PER).end_time_limit_sorted#all省略
  #   elsif params[:pri_sort]#返り値がnil
  #     @tasks = Task.page(params[:page]).per(PER).priority_sorted#all省略
  #   # elsif params[:task][:search]#undefined method `[]' for nil:NilClassとなる([]を呼び出そうとしているが、その元のオブジェクトがnilであると言っている。)
  #   elsif params[:task] && params[:task][:search]#params[:task]の返り値がnil
  #     # present?を書かないとフィールドが空欄（""）でも検索しにいってしまいエラーが起こる？
  #     if params[:task][:title].present? && params[:task][:status].present?
  #       @tasks = Task.title_status_search(params[:task][:title], params[:task][:status]).page(params[:page]).per(PER)
  #     elsif params[:task][:title].present?
  #       @tasks = Task.title_search(params[:task][:title]).page(params[:page]).per(PER)
  #     elsif params[:task][:status].present?
  #       @tasks = Task.status_search(params[:task][:status]).page(params[:page]).per(PER)
  #     elsif params[:task][:title].blank? && params[:task][:status].blank?
  #       redirect_to tasks_path, notice: t("flash.blank")
  #     end
  #   else
  #     @tasks = Task.page(params[:page]).per(PER).created_at_sorted#all省略
  #   end
  # end

  def search
    # present?を書かないとフィールドが空欄（""）でも検索しにいってしまいエラーが起こる？
    if params[:task][:title].present? && params[:task][:status].present?
      @tasks = current_user.tasks.title_status_search(params[:task][:title], params[:task][:status]).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:title].present?
      @tasks = current_user.tasks.title_search(params[:task][:title]).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:status].present?
      @tasks = current_user.tasks.status_search(params[:task][:status]).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:title].blank? && params[:task][:status].blank?
      flash[:danger] = t("flash.blank")
      redirect_to tasks_path
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)#この時点では外部キーのuser_idの値はnil
    @task.user_id = current_user.id#現在ログインしているuserのidを、@taskのuser_idカラムに挿入する。
    if @task.save
      flash[:success] = t("flash.create")
      redirect_to task_path(@task.id)
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
      flash[:success] = t("flash.update")
      redirect_to tasks_path
    else
      render "edit"
    end
  end

  def destroy
    @task.destroy
    flash[:success] = t("flash.destroy")
    redirect_to tasks_path
  end

  private

  def set_params
    @task = Task.find(params[:id])
  end

  def login_check
    unless logged_in?
      flash[:info] = t("flash.login_info")
      redirect_to new_session_path
    end
  end

  def task_params
    # f.datetime_field("end_time_limit")を使ったときは、permitを:end_time_limitに変更
    params.require(:task).permit(:title, :content, :status, :priority,
                                 "end_time_limit(1i)", "end_time_limit(2i)", "end_time_limit(3i)", "end_time_limit(4i)", "end_time_limit(5i)")
  end
end
