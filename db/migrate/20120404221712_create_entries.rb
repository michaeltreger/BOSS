class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :description
      t.timestamp :start_time
      t.timestamp :end_time
      t.boolean :repeating
      t.boolean :finalized
      t.string :entry_type
      t.string :initials

      t.references :user
      t.references :substitution
      t.references :calendar
      t.references :lab

      t.timestamps
    end
  end
end
