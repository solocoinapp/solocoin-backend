class RedeemedRewardSerializer < ApplicationSerializer
  attributes :coupon_code, :offer_name

  def coupon_code
    object.rewards_sponsor.coupon_code
  end

  def offer_name
    object.rewards_sponsor.offer_name
  end
end
