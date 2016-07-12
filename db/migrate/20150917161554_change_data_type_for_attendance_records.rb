class ChangeDataTypeForAttendanceRecords < ActiveRecord::Migration
  def change

    change_column :attendance_records, :attendance_status_id, :integer

  end
end
