class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 500 }
  validates :end_time_limit, presence: true
  validates :status, presence: true
  scope :created_at_sorted, -> { order(created_at: :desc) }#created_atカラムを降順で取得する
  scope :end_time_limit_sorted, -> { order(end_time_limit: :desc) }#end_time_limitカラムを降順で取得する
  enum status: { waiting: 0, working: 1, completed: 2 }#enumを使えば、数字を意味のある文字として扱える
end
