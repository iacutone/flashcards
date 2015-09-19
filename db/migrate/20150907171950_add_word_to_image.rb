class AddWordToImage < ActiveRecord::Migration
  def change
    add_column :images, :word, :string
  end
end
