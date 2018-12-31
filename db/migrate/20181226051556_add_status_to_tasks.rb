class AddStatusToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :integer, null: false, default: 0
    add_index :tasks, :title
  end
end
