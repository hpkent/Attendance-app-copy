class ChangeTableNametoStudentsSitting < ActiveRecord::Migration
  def change
    rename_table :student_sittings, :students_sittings
  end
end
