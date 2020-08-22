module UserRailsAdminConf
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :name
        field :mobile
        field :city
        field :country_name
        field :wallet_balance
      end
    end
  end
end
