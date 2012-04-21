class AddSubmissionTimeToTimeOffRequests < ActiveRecord::Migration
  def change
    add_column :time_off_requests, :submission, :datetime
  end
end
