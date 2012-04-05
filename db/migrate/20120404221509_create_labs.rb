class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.text :description
      t.string :name
      t.string :initials
      t.integer :max_employees
      t.integer :min_employees

      t.references :calendar
      t.references :entry
      t.references :lab_users

      t.timestamps
    end
  end
end
