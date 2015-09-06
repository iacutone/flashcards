class Api::V1::UsersController < ApplicationController
  # skip_before_filter :verify_authenticity_token
  # respond_to :json

  def sign_in
    binding.pry
  end

  if params['truck']
      truck = Truck.new(params['truck'].permit(:email, :password, :name))
      if truck.save
        sign_in(truck)
        render(
                status: 200,
                json: {
                  success: true,
                  data: {
                    truck: truck,
                    auth_token: current_truck.token,
                    name: truck.name,
                    id: truck.id.to_s,
                    kind: "truck"
                  }
                }
              )
      else
        render(
                status: :unprocessable_entity,
                json: {
                  success: false,
                  info: truck.errors.full_messages,
                  data: {}
                }
              )
      end
    elsif params['user']
      user = User.new(params['user'].permit(:email, :password, :name))
      if user.save
        sign_in(user)
        render(
                status: 200,
                json: {
                  success: true,
                  data: {
                    user: user,
                    auth_token: current_user.token,
                    name: user.name,
                    id: user.id.to_s,
                    kind: "user"
                  }
                }
              )
      else
        render(
                status: :unprocessable_entity,
                json: {
                  success: false,
                  info: user.errors.full_messages,
                  data: {}
                }
              )
      end
end
