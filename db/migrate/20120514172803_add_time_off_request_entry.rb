class AddTimeOffRequestEntry < ActiveRecord::Migration
  def up
    add_column :entries, :time_off_request_id, :integer
  end

  def down
  end
end
