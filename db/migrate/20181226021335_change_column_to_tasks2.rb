class ChangeColumnToTasks2 < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :title, :string, null: false, limit: 100
    change_column :tasks, :content, :string, null: false, limit: 500
  end

  def down
    change_column :tasks, :title, :string, null: false, limit: 30
    change_column :tasks, :content, :string, null: false, limit: 255
  end
end
