class AddDetailsToSittings < ActiveRecord::Migration
  def change
    add_column :sittings, :event_title, :string
    add_column :sittings, :start_date, :date
    add_column :sittings, :end_date, :date
    add_column :sittings, :start_time, :time
    add_column :sittings, :end_time, :time
    remove_column :sittings, :date, :date
  end
end
