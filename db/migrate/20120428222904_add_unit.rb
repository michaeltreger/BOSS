class AddUnit < ActiveRecord::Migration
  def up
    add_column :groups, :unit, :boolean, :default => false
  end

  def down
    remove_colum :groups, :unit
  end
end
