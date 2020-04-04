class Api::V1::CallbacksController < Api::BaseController
  skip_before_action :authenticate_with_token
  before_action :validate_country_code, :validate_mobile_number, :validate_uid, :validate_id_token, :verify_firebase_token

  def mobile_login
    @user = User.find_by(mobile: mobile_provider_params[:mobile])

    if @user.present?
      render_success
    else
      render json: {}, status: :unauthorized
    end
  end

  def mobile_sign_up
    @user = User.onboard_from_mobile(mobile_provider_params)

    if @user.valid?
      render_success
    else
      render_validation_errors(@user)
    end
  end

  private

  def verify_firebase_token
    unless firebase_info_exists?
      if action_name == 'mobile_login'
        render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unauthorized
      else
        render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unprocessable_entity
      end
    end
  end

  def firebase_info_exists?
    Clients::FirebaseClient.instance.info_exists?(mobile_provider_params[:id_token],
                                                  mobile_provider_params[:country_code],
                                                  mobile_provider_params[:mobile])
  end

  def validate_country_code
    return if mobile_provider_params[:country_code]
    render_failure(t('general.required_field', field: 'Country Code'))
  end

  def validate_mobile_number
    return if mobile_provider_params[:mobile]
    render_failure(t('general.required_field', field: 'Mobile number'))
  end

  def validate_uid
    return if mobile_provider_params[:uid]
    logger.error("Firebase uid not passed in params. params: #{mobile_provider_params}")
    render_failure(t('callbacks.provider_token_verification_failure'))
  end

  def validate_id_token
    return if mobile_provider_params[:id_token]
    logger.error("Firebase token not passed in params. params: #{mobile_provider_params}")
    render_failure(t('callbacks.provider_token_verification_failure'))
  end

  def render_success
    render json: { auth_token: @user.fetch_auth_token, id: @user.id }, status: :ok
  end

  def render_failure(error=nil)
    render json: { error: error || @error_message }, status: :bad_request
  end

  def mobile_provider_params
    params.require(:user).permit(:uid, :country_code, :mobile, :name, :id_token)
  end
end
