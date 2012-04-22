class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :user_id
      t.integer :period_id
      t.integer :hours_min
      t.integer :hours_max
      t.integer :hours_pref
      t.integer :hours_day
      t.string :dispersal
      t.string :timeof_week
      t.string :timeof_day
      t.string :other

      t.timestamps
    end
  end
end
