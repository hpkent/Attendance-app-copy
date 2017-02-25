class AddMeetingIdtoStudentsSittings < ActiveRecord::Migration
  def change
    add_column :students_sittings, :meeting_id, :integer
  end
end
