class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.integer :calendar_type
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
