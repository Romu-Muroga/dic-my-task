class ChangeColumnToTasks < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :end_time_limit, :datetime, null: false, default: -> { 'NOW()' }
  end

  def down
    change_column :tasks, :end_time_limit, :datetime, null: false, default: DateTime.now
  end
end
