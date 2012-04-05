class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.integer :calendar_type
      t.string :name
      t.text :description
        
      t.references :lab
      t.references :entries
      t.references :user

      t.timestamps
    end
  end
end
