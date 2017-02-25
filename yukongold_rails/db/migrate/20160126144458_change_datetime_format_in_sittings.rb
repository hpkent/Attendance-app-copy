class ChangeDatetimeFormatInSittings < ActiveRecord::Migration
  def change
    change_column :sittings, :start_time, :datetime
    change_column :sittings, :end_time, :datetime
  end
end
