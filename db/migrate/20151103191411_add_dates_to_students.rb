class AddDatesToStudents < ActiveRecord::Migration
  def change
    add_column :students, :days_since_last_seen, :integer
    add_column :students, :date_last_seen, :date
  end
end
