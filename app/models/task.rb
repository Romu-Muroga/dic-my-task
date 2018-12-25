class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 255 }
  validates :end_time_limit, presence: true
  scope :created_at_sorted, -> { order(created_at: :desc) }#created_atカラムを降順で取得する
  scope :end_time_limit_sorted, -> { order(end_time_limit: :desc) }#end_time_limitカラムを降順で取得する
end
