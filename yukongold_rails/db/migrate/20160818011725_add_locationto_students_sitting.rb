class AddLocationtoStudentsSitting < ActiveRecord::Migration
  def change
    add_column :students_sittings, :location, :integer
  end
end
