class AddOrderToCategoryType < ActiveRecord::Migration
  def change
    add_column :category_types, :order, :integer
  end
end
