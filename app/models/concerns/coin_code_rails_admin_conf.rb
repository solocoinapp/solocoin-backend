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
      # configure :user do
      #   hide
      # end
      # configure :status do
      #   visible do
      #     bindings[:view]._current_user.role == "admin"
      #   end
      # end
      # configure :coins do
      #   visible do
      #     bindings[:view]._current_user.role == "admin"
      #   end
      # end
    end
  end
end
