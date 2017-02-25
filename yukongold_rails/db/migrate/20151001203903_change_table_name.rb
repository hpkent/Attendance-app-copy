class ChangeTableName < ActiveRecord::Migration
  def change
    rename_table :attendance_records, :student_sittings
  end
end
