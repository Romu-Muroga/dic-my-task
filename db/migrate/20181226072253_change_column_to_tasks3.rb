class ChangeColumnToTasks3 < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :status, :string
    add_column :tasks, :status, :integer, null: false, default: 0
  end
end
