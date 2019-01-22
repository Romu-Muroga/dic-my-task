class Label < ApplicationRecord
  # バリデーション
  validates :name, presence: true, length: { in: 1..100 }
  # アソシエーション
  has_many :task_labels
  has_many :labeled_tasks, through: :task_labels, source: :task
end
