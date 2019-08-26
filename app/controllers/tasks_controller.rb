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
    if params[:task][:title].present? && params[:task][:status].present? && params[:task][:label_id].present?
      label_tasks = Label.label_search(params[:task][:label_id])
      @tasks = label_tasks.title_status_current_user_search(params[:task][:title],
                                                            params[:task][:status],
                                                            current_user.id
                                                           ).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:title].present? && params[:task][:label_id].present?
      label_tasks = Label.label_search(params[:task][:label_id])
      @tasks = label_tasks.title_current_user_search(params[:task][:title],
                                                     current_user.id
                                                    ).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:status].present? && params[:task][:label_id].present?
      label_tasks = Label.label_search(params[:task][:label_id])
      @tasks = label_tasks.status_current_user_search(params[:task][:status],
                                                      current_user.id
                                                     ).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:title].present? && params[:task][:status].present?
      @tasks = current_user.tasks.title_status_search(params[:task][:title],
                                                      params[:task][:status]
                                                     ).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:title].present?
      @tasks = current_user.tasks.title_search(params[:task][:title]).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:status].present?
      @tasks = current_user.tasks.status_search(params[:task][:status]).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:label_id].present?
      label_tasks = Label.label_search(params[:task][:label_id])
      @tasks = label_tasks.current_user_narrow_down(current_user.id).page(params[:page]).per(PER)
      render "index"
    elsif params[:task][:title].blank? && params[:task][:status].blank?
      flash[:warning] = t("flash.blank")
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
      # @taskがsaveできたタイミングで同時に中間テーブルのtask_labelsテーブルにtask_idとlabel_idに値を保存する。
      if params[:task][:label_ids].present?
        params[:task][:label_ids].each do |label_id|
          TaskLabel.create(task_id: @task.id, label_id: label_id)
        end
      end
      flash[:success] = t("flash.create")
      redirect_to task_path(@task.id)
    else
      render "new"
    end
  end

  def show
  end

  def edit
    @task_label_ids = @task.labels_attached_to_task.pluck(:id)
  end

  def update
    if @task.update(task_params)
      if params[:task][:label_ids].present?
        # @task.idと同じtask_idを持つ中間テーブルのレコードを全削除
        @task.task_labels.each do |task_label|
          task_label.destroy if task_label.task_id == @task.id
        end
        # params[:task][:label_ids]で送られてきたlabel_idの数だけ中間テーブルのレコードを新規作成
        params[:task][:label_ids].each do |label_id|
          TaskLabel.create(task_id: @task.id, label_id: label_id)
        end
      else
        # タスクに付いていたラベルを全て外したとき、@task.idと同じidを持つ中間テーブルのtask_idのレコードを全削除
        @task.task_labels.each do |task_label|
          task_label.destroy if task_label.task_id == @task.id
        end
      end
      flash[:success] = t("flash.update")
      redirect_to task_path(@task.id)
    else
      # 編集が失敗したとき、editアクションに戻る前に@task_label_idsを_form.html.erbに送ってあげないと
      # NoMethodError - undefined method `include?' for nil:NilClassが起こる。
      @task_label_ids = @task.labels_attached_to_task.pluck(:id)
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
    if logged_in? == false
      flash[:danger] = t("flash.login_info")
      redirect_to login_path
    elsif logged_in? == false && (@task.user_id == current_user.id) == false
      flash[:danger] = t("flash.login_alert")
      redirect_to login_path
    end
  end

  def task_params
    # f.datetime_field("end_time_limit")を使ったときは、permitを:end_time_limitに変更
    params.require(:task).permit(:title, :content, :status, :priority, :label_ids,
                                 "end_time_limit(1i)", "end_time_limit(2i)", "end_time_limit(3i)", "end_time_limit(4i)", "end_time_limit(5i)")
  end
end
