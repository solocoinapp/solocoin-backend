class RewardsSponsor < ApplicationRecord
  belongs_to :user, inverse_of: :rewards_sponsors
  rails_admin do
    configure :user do
      hide
    end
  end
end
