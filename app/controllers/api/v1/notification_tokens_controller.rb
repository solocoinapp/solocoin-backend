class Api::V1::NotificationTokensController < Api::BaseController

  def create
    @notification_token = current_user.notification_tokens.find_or_create_by(value: notification_token_params[:token])
    if @notification_token.valid?
      render json: {}, status: :created
    else
      render_error(:unprocessable_entity, @notification_token.errors.full_messages.to_sentence)
    end
  end

  private

  def notification_token_params
    params.require(:user).permit(:token)
  end
end
