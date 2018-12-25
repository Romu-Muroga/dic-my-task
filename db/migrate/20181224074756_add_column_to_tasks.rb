class AddColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :end_time_limit, :datetime, null: false, default: DateTime.now
  end
end
