class Api::V1::CallbacksController < Api::BaseController
  skip_before_action :authenticate_with_token
  before_action :verify_firebase_token, :validate_country_code, :validate_mobile_number, :validate_uid, :validate_id_token
  before_action :validate_name, only: :mobile_sign_up

  def mobile_login
    @user = User.find_by!(mobile: mobile_provider_params[:mobile])
    render_success
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
    unless Clients::FirebaseClient.instance.info_exists?(mobile_provider_params[:id_token],
                                                         mobile_provider_params[:country_code],
                                                         mobile_provider_params[:mobile])
      render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unprocessable_entity
    end
  end

  def validate_country_code
    return if mobile_provider_params[:country_code]
    render json: { error: t('general.required_field', field: 'Country Code') }, status: :unprocessable_entity
  end

  def validate_mobile_number
    return if mobile_provider_params[:mobile]
    render json: { error: t('general.required_field', field: 'Mobile number') }, status: :unprocessable_entity
  end

  def validate_uid
    return if mobile_provider_params[:uid]
    logger.error("Firebase uid not passed in params. params: #{mobile_provider_params}")
    render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unprocessable_entity
  end

  def validate_name
    return if mobile_provider_params[:name]
    render json: { error: t('general.required_field', field: 'Name')}, status: :unprocessable_entity
  end

  def validate_id_token
    return if mobile_provider_params[:id_token]
    logger.error("Firebase token not passed in params. params: #{mobile_provider_params}")
    render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unprocessable_entity
  end

  def render_success
    render json: { auth_token: @user.fetch_auth_token, id: @user.id }, status: :ok
  end

  def render_failure
    render json: { error: @error_message }, status: :bad_request
  end

  def mobile_provider_params
    params.require(:user).permit(:uid, :country_code, :mobile, :name, :id_token)
  end
end
