class Api::V1::UploadsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def data
    s3        = S3Coordinator.new
    user      = User.find_by(email: params[:email])
    file_name = "#{user.email} #{Time.now.to_s(:number)}.png"
    image     = s3.upload_image(params['photo'].tempfile, file_name)
    image_url = image.url_for(:read).to_s

    image = Image.new(user_id: user.id, image_url: image_url, word: params[:image_name], file_name: file_name)

    if image.save
      render(status: 200)
    else
      render(
            status: 400,
            json: {
              success: false,
              info: "You have not uploaded and images."
            }
          ) and return
    end
  end

  def images
    user           = User.find_by(email: params[:email])
    image_size     = user.images.size
    # increment      = params[:increment].to_i
    # count          = params[:count].to_i
    image = user.images.first

    # image = user.images.first

    # if count > image_size
    #   count = 0
    # elsif count < 0
    # else
    # end
    
    s3 = S3Coordinator.new

    if user.present? && user.images.present?
      render(
              status: 200,
              json: {
                success: true,
                data: {
                  s3_url: s3.fetch_image_url(image.file_name),
                  word: image.word
                  # increment: increment,
                  # count: count
                }
              }
            ) and return
    else
      render(
            status: 400,
            json: {
              success: false,
              info: "You have not uploaded and images."
            }
          ) and return
    end
  end
end
