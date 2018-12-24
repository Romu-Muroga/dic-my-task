class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 255 }
  scope :sorted, -> { order(created_at: :desc) }#created_atカラムを降順で取得する
end
