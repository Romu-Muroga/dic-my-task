class CreateTaskLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :task_labels do |t|
      t.references :task, foreign_key: { on_delete: :cascade }, null: false
      t.references :label, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
    add_index :task_labels, [:task_id, :label_id], unique: true
  end
end
