class Api::V1::CoinCodesController < Api::BaseController
  before_action :validate_coupon, only: [:redeem_coupon,:valid_coupon]
  # Redeem coupon
  # Add coupon money to balance
  def redeem_coupon
    coin_codes = current_user.coin_codes.blank? ? {} : current_user.coin_codes
    coin_codes["#{@coupon.id}"] = @coupon.coupon_code
    wallet_balance = current_user.wallet_balance.to_f + @coupon.amount.to_f
    current_user.update(wallet_balance: wallet_balance, coin_codes: coin_codes)
    limit = @coupon.limit - 1
    @coupon.update(limit: limit)
    render json: {success: true, message: "Successfully Redeemed!"}
  end

  def valid_coupon
    render json: {success: true, message: "Valid Coupen"}
  end

  def referral
    params[:amount] = "500"
    return render_error(:unprocessable_entity, 'Invalid Referral!') if params[:referral_code].blank?
    referral_user = User.find_by(auth_token: params[:referral_code])
    return render_error(:unprocessable_entity, 'Invalid Referral!') if referral_user.blank?
    return render_error(:unprocessable_entity, 'Invalid Amount!') if params[:amount].to_f <= 0
    user_updated_balance = current_user.wallet_balance.to_f + params[:amount].to_f
    referral_user_updated_balance = referral_user.wallet_balance.to_f + params[:amount].to_f
    current_user.update(wallet_balance: user_updated_balance)
    referral_user.update(wallet_balance: referral_user_updated_balance)
    render json: {success: true, message: "Successfully!"}
  end

  private

  def validate_coupon
    @coupon = CoinCode.find_by(coupon_code: params[:coupon])
    return render_error(:unprocessable_entity, 'Invalid Coupon!') if @coupon.blank? || @coupon.amount < 1
    return render_error(:unprocessable_entity, 'Expired Coupon!') if @coupon.limit == 0
    redeem_coupens = current_user.coin_codes
    if redeem_coupens.present? && redeem_coupens.values.include?(params[:coupon])
      render_error(:unprocessable_entity, 'Coupon Already Used!')
    end
  end

end
