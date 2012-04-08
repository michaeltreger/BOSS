class AddSubstitutionsUsersTable < ActiveRecord::Migration
  def up
    create_table :substitutions_users, :id => false do |t|
      t.integer :substitution_id
      t.integer :user_id
    end
  end

  def down
    drop_table :substitutions_users
  end
end
