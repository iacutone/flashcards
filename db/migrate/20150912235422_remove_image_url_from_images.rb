class RemoveImageUrlFromImages < ActiveRecord::Migration
  def change
    remove_column :images, :image_url, :string
  end
end
