class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :end_time_limit, presence: true
  validates :status, presence: true

  scope :created_at_sorted, -> { order(created_at: :desc) }#created_atカラムを降順で取得する
  scope :end_time_limit_sorted, -> { order(end_time_limit: :desc) }#end_time_limitカラムを降順で取得する
  scope :title_search, -> (title) { where("title LIKE ?", "%#{ title }%") }#引数（title）で受け取った値と一致するレコードのみ検索
  scope :status_search, -> (status) { where(status: status) }#引数（status）で受け取った値と一致するレコードのみ検索
  scope :title_status_search, -> (title, status) { where("title LIKE ?", "%#{ title }%").where(status: status) }#引数（title, status）で受け取った値と両方成り立つレコードを検索

  enum status: { waiting: 0, working: 1, completed: 2 }#enumを使えば、数字を意味のある文字として扱える。DBには割り当てられた整数が保存される。
end
