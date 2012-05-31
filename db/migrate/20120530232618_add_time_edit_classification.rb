class AddTimeEditClassification < ActiveRecord::Migration
  def up
    add_column :time_edits, :classification, :string
  end

  def down
  end
end
