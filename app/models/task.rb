class Task < ApplicationRecord
  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validate :validate_title_not_including_comma
  validates :content, presence: true, length: { maximum: 500 }
  validates :end_time_limit, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  # scope
  scope :created_at_sorted, -> { order(created_at: :desc) }#created_atカラムを降順で取得する
  scope :end_time_limit_sorted, -> { order(end_time_limit: :desc) }#end_time_limitカラムを降順で取得する
  scope :priority_sorted, -> { order(priority: :desc) }#priorityカラムを降順で取得する
  scope :title_search, -> (title) { where("title LIKE ?", "%#{ title }%") }#引数（title）で受け取った値と一致するレコードのみ検索
  scope :status_search, -> (status) { where(status: status) }#引数（status）で受け取った値と一致するレコードのみ検索
  scope :title_status_search, -> (title, status) { where("title LIKE ?", "%#{ title }%").where(status: status) }#引数（title, status）で受け取った値と両方成り立つレコードを検索

  scope :title_status_current_user_search, -> (title, status, current_user_id) { where("title LIKE ?", "%#{ title }%").where(status: status).where(user_id: current_user_id) }
  scope :title_current_user_search, -> (title, current_user_id) { where("title LIKE ?", "%#{ title }%").where(user_id: current_user_id) }
  scope :status_current_user_search, -> (status, current_user_id) { where(status: status).where(user_id: current_user_id) }
  scope :current_user_narrow_down, -> (current_user_id) { where(user_id: current_user_id) }#そのラベルに紐付けられたタスクの中からログイン中のユーザーのタスクのみに絞り込む

  # enumを使えば、数字を意味のある文字として扱える。DBには割り当てられた整数が保存される。
  enum status: { waiting: 0, working: 1, completed: 2 }#ステータス
  enum priority: { row: 0, medium: 1, high: 2 }#優先順位
  # アソシエーション
  belongs_to :user
  has_many :task_labels#関連するテーブルの削除方法はDBにforeign_key: {on_delete: :cascade}を付与したためdependent: :destroyはなし。
  has_many :labels_attached_to_task, through: :task_labels, source: :label#そのタスクに付けられた全ラベルを取得するとき

  private

  def validate_title_not_including_comma
    errors.add(:title, 'にカンマを含めることはできません') if title&. include?(',')
  end
end
