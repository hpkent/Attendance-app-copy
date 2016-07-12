class CreateAttendanceRecords < ActiveRecord::Migration
  def change
    create_table :attendance_records do |t|
      t.integer :sitting_id
      t.integer :student_id
      t.string :attendance_status_id
      t.boolean :in_retreat
      
      t.timestamps null: false
    end
  end
end
