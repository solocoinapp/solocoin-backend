module RailsAdminConf
  extend ActiveSupport::Concern

  included do
    rails_admin do
      field :name do
        help nil
      end
      field :answers do
        help nil
      end
      field :active do
        help nil
      end
    end
  end
end
