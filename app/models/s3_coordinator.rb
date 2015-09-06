class S3Coordinator
  attr_reader :bucket

  def initialize
    @s3 = AWS::S3.new(
          :access_key_id     => ENV['AWSAccessKeyId'],
          :secret_access_key => ENV['AWSSecretKey']
        )
    @bucket = @s3.buckets[ENV['AWSBucket']]
  end

  def upload_image(file, filename)
    bucket.objects[filename].write(:file => file)
  end
end
