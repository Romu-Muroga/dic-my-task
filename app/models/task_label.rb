class TaskLabel < ApplicationRecord
  # バリデーション

  # アソシエーション
  belongs_to :task
  belongs_to :label
end
