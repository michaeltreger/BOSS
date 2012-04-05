class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_type
      t.string :name
      t.string :email
      t.integer :cas_user

      t.timestamps
    end
  end
end
