class AddColumnConstraintsToUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
    change_column :users, :identifier, :bigint, null: false
    change_column :users, :api_token, :string, null: false
  end

  def down
    change_column :users, :email, :string, null: true
    change_column :users, :password_digest, :string, null: true
    change_column :users, :identifier, :bigint, null: true
    change_column :users, :api_token, :string, null: true
  end
end
