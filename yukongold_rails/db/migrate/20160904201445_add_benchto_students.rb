class AddBenchtoStudents < ActiveRecord::Migration
  def change
    add_column :students, :bench, :boolean
  end
end
