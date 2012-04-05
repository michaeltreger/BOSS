class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :type
      t.string :name
      t.string :email
      t.integer :cas_user

      t.timestamps
    end
  end
end
