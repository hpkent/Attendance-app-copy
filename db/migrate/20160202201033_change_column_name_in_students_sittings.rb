class ChangeColumnNameInStudentsSittings < ActiveRecord::Migration
  def change
    rename_column :students_sittings, :in_retreat, :special_status_type_id
  end
end
