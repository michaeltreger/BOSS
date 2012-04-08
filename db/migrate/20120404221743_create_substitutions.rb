class CreateSubstitutions < ActiveRecord::Migration
  def change
    create_table :substitutions do |t|
      t.text :description
      t.references :user
      t.references :entry

      t.timestamps
    end
  end
end
