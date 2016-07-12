class ChangeColumnTypeInStudentsSittings < ActiveRecord::Migration
  def change
    change_column :students_sittings, :special_status_type_id, :integer
  end
end
