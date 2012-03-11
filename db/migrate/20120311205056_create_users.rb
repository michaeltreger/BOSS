class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :type
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
