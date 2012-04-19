class CreateTimeOffRequests < ActiveRecord::Migration
  def change
    create_table :time_off_requests do |t|
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :day_notice

      t.references :user

      t.timestamps
    end
  end
end
