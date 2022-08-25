class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid 
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id 
        render json: user, status: :created
    end

    def show 
        user = User.find_by(id: session[:user_id])
        if session.include? :user_id
            render json: user, status: :ok
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end

    private

    def render_invalid(invalid)
        render json: {errors: invalid.record.errors}, status: :unprocessable_entity
    end

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
end
