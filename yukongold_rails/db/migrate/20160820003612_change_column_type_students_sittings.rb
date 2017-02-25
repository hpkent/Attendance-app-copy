class ChangeColumnTypeStudentsSittings < ActiveRecord::Migration
  def change
    rename_column :students_sittings, :location_type_id, :hatto
    change_column :students_sittings, :hatto, :boolean, default: 0
  end
end
