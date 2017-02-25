class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :level
      t.date :acceptance_date
      t.string :email
      t.string :dietary_restrictions
      t.text :other

      t.timestamps null: false
    end
  end
end
