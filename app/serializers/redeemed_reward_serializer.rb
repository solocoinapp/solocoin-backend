class RedeemedRewardSerializer < ApplicationSerializer
  attributes :rewards_sponsor_id, :coupon_code, :offer_name

  def rewards_sponsor_id
    object.rewards_sponsor.id
  end

  def coupon_code
    object.rewards_sponsor.coupon_code
  end

  def offer_name
    object.rewards_sponsor.offer_name
  end
end
