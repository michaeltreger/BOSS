class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.text :description
      t.string :name
      t.string :initials
      t.integer :max_employees
      t.integer :min_employees

      t.timestamps
    end
  end
end
