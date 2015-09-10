class Api::V1::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def sign_up

    if request.post?
      if params && params[:email] && params[:password]

        encrypted_password = params['password'].gsub(" ","+").concat("\n")
        decrypted_password = AESCrypt.decrypt(encrypted_password, ENV['AuthPassword'])
        
        user = User.new(email: params[:email], password: decrypted_password, password_confirmation: decrypted_password)

        if user.save
          render(
                  status: 200,
                  json: {
                    success: true,
                    data: {
                      id: user.id,
                      email: user.email
                    }
                      
                  }
                ) and return
        else
          render(
                  status: 400,
                  json: {
                    success: false,
                    info: user.errors.full_messages.first
                  }
                ) and return
        end
      end
    end
  end

  def sign_in
    if request.post?
      if params[:email].present? && params[:password].present? 

        user = User.find_by(email: params[:email])
                      
        if user.present? 
          if user.authenticate(params[:password])    
            render :json => user.to_json, :status => 200
          else
            render(
                  status: 400,
                  json: {
                    success: false,
                    info: "Incorrect password"
                  }
                ) and return
          end      
        else
          render(
                  status: 400,
                  json: {
                    success: false,
                    info: "User not found."
                  }
                ) and return
        end
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :token)
    end
end
