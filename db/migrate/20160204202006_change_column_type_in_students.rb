class ChangeColumnTypeInStudents < ActiveRecord::Migration
  def change
    change_column :students, :category, :integer
  end
end
