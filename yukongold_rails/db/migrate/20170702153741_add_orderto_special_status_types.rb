class AddOrdertoSpecialStatusTypes < ActiveRecord::Migration
  def change
    add_column :special_status_types, :priority, :integer
  end
end
