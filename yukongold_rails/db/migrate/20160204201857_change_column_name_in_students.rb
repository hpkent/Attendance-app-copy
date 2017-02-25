class ChangeColumnNameInStudents < ActiveRecord::Migration
  def change
    rename_column :students, :level, :category
  end
end
