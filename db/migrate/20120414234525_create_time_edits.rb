class CreateTimeEdits < ActiveRecord::Migration
  def change
    create_table :time_edits do |t|
      t.integer :user_id
      t.integer :calendar_id
      t.datetime :start_time
      t.integer :duration
      t.integer :lab_id
      t.string :comment

      t.timestamps
    end
  end
end
