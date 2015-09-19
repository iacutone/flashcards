class Image < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :file_name, :word
end
