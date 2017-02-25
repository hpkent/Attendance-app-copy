class ChangeColumnNameInStudentsToCategoryId < ActiveRecord::Migration
  def change
    rename_column :students, :category, :category_type_id
  end
end
