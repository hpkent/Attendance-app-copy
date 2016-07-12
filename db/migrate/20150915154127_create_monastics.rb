class CreateMonastics < ActiveRecord::Migration
  def change
    create_table :monastics do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :initials
      t.string :email

      t.timestamps null: false
    end
  end
end
