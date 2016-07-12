class ChangeColumnName < ActiveRecord::Migration
  def change

    rename_column :attendance_records, :attendance_status_id, :attendance_status_record_id

  end
end
