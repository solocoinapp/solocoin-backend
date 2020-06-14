module CategoryRailsAdminConf
  extend ActiveSupport::Concern

  included do
    rails_admin do
      field :name do
        help nil
      end
    end
  end
end
