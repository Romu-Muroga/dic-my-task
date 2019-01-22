class TaskLabel < ApplicationRecord
  # バリデーション
  
  # アソシエーション
  belongs_to :task, inverse_of: :task_labels
  belongs_to :label
end
