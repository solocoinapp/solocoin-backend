module CoinCodeRailsAdminConf
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :coupon_code
        field :amount
        field :limit
      end
      create do
        field :coupon_code
        field :amount
        field :limit
      end
    end
  end
end
