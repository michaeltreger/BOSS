class CreateGroupLabs < ActiveRecord::Migration
  def change
    create_table :group_labs do |t|
      t.references :group
      t.references :lab
      
      t.timestamps
    end
  end
end
