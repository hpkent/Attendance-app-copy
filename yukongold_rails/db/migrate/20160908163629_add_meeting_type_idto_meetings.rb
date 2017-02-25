class AddMeetingTypeIdtoMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :meeting_type_id, :integer
  end
end
