class Api::V1::UsersController < Api::BaseController
  def show
    render json: current_user
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def register_notification_token
    @notification_token = current_user.notification_tokens.find_or_create_by(value: notification_token_params[:token])

    if @notification_token.valid?
      render json: {}, status: :created
    else
      render_error(:unprocessable_entity, @notification_token.errors.full_messages.to_sentence)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :mobile, :profile_picture, :lat, :lng)
  end

  def notification_token_params
    params.require(:user).permit(:token)
  end
end
