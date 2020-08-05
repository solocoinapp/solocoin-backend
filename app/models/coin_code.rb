class CoinCode < ApplicationRecord
  include CoinCodeRailsAdminConf

  validates_presence_of :coupon_code, :amount, :limit

end
