class ChangeColumnNametoAttendanceStatusTypeId < ActiveRecord::Migration
  def change
        rename_column :attendance_records, :attendance_status_record_id, :attendance_status_type_id
  end
end
