class CoinCode < ApplicationRecord
  include CoinCodeRailsAdminConf

  validates_presence_of :coupon_code, :amount, :limit
  validates_uniqueness_of :coupon_code
  validates :limit, numericality: { greater_than_or_equal_to: 0 }
  validates :amount, numericality: { greater_than: 0 }

end
