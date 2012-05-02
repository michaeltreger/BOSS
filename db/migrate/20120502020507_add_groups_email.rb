class AddGroupsEmail < ActiveRecord::Migration
  def up
    add_column :groups, :email, :text
  end

  def down
    remove_column :groups, :email
  end
end
