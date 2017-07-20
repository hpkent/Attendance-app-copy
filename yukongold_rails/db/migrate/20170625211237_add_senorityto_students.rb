class AddSenoritytoStudents < ActiveRecord::Migration
  def change
    add_column :students, :senority, :integer
  end
end
