class Api::V1::UploadsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def data
    s3        = S3Coordinator.new
    user      = User.find_by(email: params[:email])
    file_name = "#{user.email} #{Time.now.to_s(:number)}.jpg"
    image     = MiniMagick::Image.new(params['photo'].tempfile.path)
    image.resize "375x375"
    s3_image  = s3.upload_image(image.path, file_name)

    image = Image.new(user_id: user.id, word: params[:image_name], file_name: file_name)

    if image.save
      render(status: 200)
    else
      render(
            status: 200,
            json: {
              success: false,
              info: "You have not uploaded and images."
            }
          ) and return
    end
  end

  def select_image
    user        = User.find_by(email: params[:email])
    user_count  = user.counter
    image_count = user.images.not_hidden.size
    increment   = params[:increment].to_i

    if user_count + increment >= image_count
      user.counter = 0
      user.save!
    elsif user_count + increment < 0
      user.counter = image_count - 1
      user.save!
    else
      user.counter = user_count + increment
      user.save!
    end

    image = user.images[user.counter]
    
    s3 = S3Coordinator.new

    if user.present? && user.images.present?
      render(
              status: 200,
              json: {
                success: true,
                data: {
                  s3_url: s3.fetch_image_url(image.file_name),
                  word: image.word
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

  def images
    user = User.find_by(email: params[:email])

    if user.present? && user.images.present?
      render(
              status: 200,
              json: {
                success: true,
                data: {
                  images: user.images.not_hidden
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

  def edit_image
    image = Image.find(params[:image_id])
    image.word = params[:word]
    
    if image.save
      render(
              status: 200,
              json: {
                success: true
              }
            ) and return
    else
      render(
            status: 200,
            json: {
              success: false,
              info: image.errors.first
            }
          ) and return
    end
  end

  def hide_image
    user  = User.find_by(email: params[:email])
    image = Image.find(params[:image_id])
    image.hidden = true
    
    if image.save
      render(
              status: 200,
              json: {
                success: true,
                data: {
                  images: user.images.not_hidden
                }
              }
            ) and return
    else
      render(
            status: 200,
            json: {
              success: false,
              info: image.errors.first
            }
          ) and return
    end
  end
end
