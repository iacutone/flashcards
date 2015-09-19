class User < ActiveRecord::Base
  has_secure_password

  has_many :images

  validates_presence_of :email, :password
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validates_uniqueness_of :email, :case_sensitive => false

  before_save :downcase_email
  before_save :generate_token

  def self.json_images_and_words(user)
    s3 = S3Coordinator.new

    output = []
    hashed_people = {}

    user.images.map do |image|
      hashed_people[:s3_url] = s3.fetch_image_url(image.file_name)
      hashed_people[:word] = image.word
      # output << hashed_people
    end

    hashed_people
  end

  def downcase_email
    self.email.downcase
  end
  
  def generate_token
    self.token = Digest::SHA1::hexdigest([Time.now, rand].join) 
  end
end
