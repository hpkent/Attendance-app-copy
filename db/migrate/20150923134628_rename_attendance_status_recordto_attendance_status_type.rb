class RenameAttendanceStatusRecordtoAttendanceStatusType < ActiveRecord::Migration
  def change
    rename_table :attendance_status_records, :attendance_status_types
  end
end
