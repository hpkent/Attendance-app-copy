class CreateSpecialStatusTypes < ActiveRecord::Migration
  def change
    create_table :special_status_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
