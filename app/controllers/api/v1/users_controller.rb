class Api::V1::UsersController < Api::BaseController
  def show
    render json: current_user
  end

  def update
    current_user.update!(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:name, :mobile, :profile_picture, :lat, :lng)
  end
end
