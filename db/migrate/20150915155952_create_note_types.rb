class CreateNoteTypes < ActiveRecord::Migration
  def change
    create_table :note_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
