class AddStatusToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :string, limit: 10, null: false, default: "未着手"
    add_index :tasks, :title
  end
end
