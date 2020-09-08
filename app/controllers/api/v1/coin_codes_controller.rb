class Api::V1::CoinCodesController < Api::BaseController
  before_action :validate_coupon, only: [:redeem_coupon,:valid_coupon]
  # Redeem coupon
  # Add coupon money to balance
  def redeem_coupon
    coin_codes = current_user.coin_codes.blank? ? {} : current_user.coin_codes
    coin_codes["#{@coupon.id}"] = @coupon.coupon_code
    wallet_balance = current_user.wallet_balance.to_f + @coupon.amount.to_f
    current_user.update(wallet_balance: wallet_balance, coin_codes: coin_codes, total_earned_coins: total_earned_coins(current_user, @coupon.amount.to_f))
    limit = @coupon.limit - 1
    @coupon.update(limit: limit)
    render json: {success: true, message: "Successfully Redeemed!"}
  end

  def valid_coupon
    render json: {success: true, message: "Valid Coupon"}
  end

  def referral
    return render_error(:unprocessable_entity, 'Invalid Referral!') if params[:referred_user_code].blank?
    referred_user = User.find_by(auth_token: params[:referred_user_code])
    return render_error(:unprocessable_entity, 'Invalid Referral!') if referred_user.blank?
    return render_error(:unprocessable_entity, 'Invalid Referral!') if params[:referral_coupon].blank?
    referral = Referral.find_by(code: params[:referral_coupon])
    amount = referral.amount || 500
    return render_error(:unprocessable_entity, 'Invalid Amount!') if amount.to_f <= 0
    return render_error(:unprocessable_entity, 'Invalid Use Of Token!') if referral.user == referred_user
    return render_error(:unprocessable_entity, 'Coupon Already Redeemed!') if referred_user.is_redeemed
    user_updated_balance = referral.user.wallet_balance.to_f + amount.to_f
    referral_user_updated_balance = referred_user.wallet_balance.to_f + amount.to_f
    referral.user.update(wallet_balance: user_updated_balance, total_earned_coins: total_earned_coins(referral.user, amount.to_f))
    referred_user.update(wallet_balance: referral_user_updated_balance, is_redeemed: true, total_earned_coins: total_earned_coins(referred_user, amount.to_f))
    referral.update(
      referrals_count: referral.referrals_count + 1,
      referrals_amount: referral.referrals_amount + amount
    )
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

  def total_earned_coins(user, amount)
    user.total_earned_coins + amount
  end
end
