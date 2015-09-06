class Api::V1::UploadsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def data
    s3 = S3Coordinator.new
    s3.upload_image(params['photo'].tempfile, params['photo'].original_filename)

    render(status: 200)
  end
end
