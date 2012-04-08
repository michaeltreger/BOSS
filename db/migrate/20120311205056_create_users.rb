class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :user_type
      t.string :name
      t.string :email
      t.integer :cas_user
      t.string :phone
      t.boolean :approved
      t.string :initials

      t.references :calendar
      t.references :substitution
      t.references :preference
      t.references :entry
      t.references :lab
      t.references :group
      t.references :lab_users

      t.timestamps
    end
  end
end
