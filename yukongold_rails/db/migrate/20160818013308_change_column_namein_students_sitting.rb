class ChangeColumnNameinStudentsSitting < ActiveRecord::Migration
  def change
    rename_column :students_sittings, :location, :location_type_id
  end
end
