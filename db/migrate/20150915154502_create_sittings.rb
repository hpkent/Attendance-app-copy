class CreateSittings < ActiveRecord::Migration
  def change
    create_table :sittings do |t|
      t.date :date
      t.string :note_id

      t.timestamps null: false
    end
  end
end
