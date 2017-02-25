class CreateAttendanceStatusRecords < ActiveRecord::Migration
  def change
    create_table :attendance_status_records do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
