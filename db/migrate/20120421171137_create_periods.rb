class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :visible
      t.boolean :exception
      t.integer :type

      t.timestamps
    end
  end
end
