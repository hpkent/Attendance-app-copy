class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :student_id
      t.integer :monastic_id
      t.integer :note_id
      t.integer :sitting_id

      t.timestamps null: false
    end
  end
end
