class RewardsSponsorSerializer < ApplicationSerializer
  attributes :id, :offer_name, :offer_amount, :company_name, :terms_and_conditions, :coins, :coupon_code
end
