class Category < ApplicationRecord
  include CategoryRailsAdminConf

  has_many :rewards_sponsors
end
