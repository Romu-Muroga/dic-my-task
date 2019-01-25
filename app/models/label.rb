class Label < ApplicationRecord
  # バリデーション
  validates :name, presence: true, length: { in: 1..100 }
  # scope
  scope :label_search, -> (label_id) { find_by(id: label_id).labeling_tasks }#引数（label_id）で受け取った値と一致するラベルに紐付いたタスクを全て取得
  # アソシエーション
  has_many :task_labels#関連するテーブルの削除方法はDBにforeign_key: {on_delete: :cascade}を付与したためdependent: :destroyはなし。
  has_many :labeling_tasks, through: :task_labels, source: :task#そのラベルが付けられている全タスクを取得したいとき。
end
