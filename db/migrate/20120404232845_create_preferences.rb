class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|

      t.timestamps
    end
  end
end
