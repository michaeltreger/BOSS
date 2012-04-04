class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :description
      t.timestamp :start_time
      t.timestamp :end_time
      t.boolean :repeating
      t.boolean :finalized

      t.timestamps
    end
  end
end
