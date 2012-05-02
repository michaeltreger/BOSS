class RemoveUserType < ActiveRecord::Migration
  def up
    remove_column :users, :user_type
  end

  def down
    add_column :users, :user_type, :default => 0
  end
end
