class AddHiddenToImages < ActiveRecord::Migration
  def change
    add_column :images, :hidden, :boolean, default: false
  end
end
