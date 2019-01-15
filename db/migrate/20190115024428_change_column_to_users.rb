class ChangeColumnToUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :name, :string, null: false, limit: 100
    change_column :users, :email, :string, null: false, limit: 200
    change_column :users, :password_digest, :string, null: false, limit: 200
  end

  def down
    change_column :users, :name, :string, null: false, limit: 50
    change_column :users, :email, :string, null: false, limit: 50
    change_column :users, :password_digest, :string, null: false, limit: 50
  end
end
