class RewardsSponsorSerializer < ApplicationSerializer
  attributes :id, :offer_name, :offer_amount, :company_name, :terms_and_conditions, :coins, :coupon_code, :brand_logo_url
  has_one :category, serializer: CategorySerializer

  def brand_logo_url
    object.brand_logo.url
  end
end
