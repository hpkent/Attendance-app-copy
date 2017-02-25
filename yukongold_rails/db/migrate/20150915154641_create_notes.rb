class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :note_type_id
      t.text :content

      t.timestamps null: false
    end
  end
end
