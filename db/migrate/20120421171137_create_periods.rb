class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :visible
      t.boolean :exception
      t.integer :type

      t.timestamps
    end
  end
end
