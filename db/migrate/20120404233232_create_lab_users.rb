class CreateLabUsers < ActiveRecord::Migration
  def change
    create_table :lab_users do |t|
      t.references :lab
      t.references :user
      t.boolean :admin
    
      t.timestamps
    end
  end
end
