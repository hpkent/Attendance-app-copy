class AddNewColumnStartTimeToMeetings < ActiveRecord::Migration
  def change
     add_column :meetings, :start_time, :datetime
  end
end
