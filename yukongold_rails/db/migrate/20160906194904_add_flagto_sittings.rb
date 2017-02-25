class AddFlagtoSittings < ActiveRecord::Migration
  def change
    add_column :sittings, :no_meeting_flag, :boolean
  end
end
