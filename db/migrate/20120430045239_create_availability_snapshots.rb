class CreateAvailabilitySnapshots < ActiveRecord::Migration
  def change
    create_table :availability_snapshots do |t|
      t.date :start_date
      t.date :end_date
      t.text :availabilities

      t.timestamps
    end
  end
end
