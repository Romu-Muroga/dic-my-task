class AddNullFalseToTasks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :user_id, false
  end
end
