class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :group_type
      t.integer :hour_limit
      t.text :description

      t.timestamps
    end
  end
end
