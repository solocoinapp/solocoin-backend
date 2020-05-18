class RewardsSponsor < ApplicationRecord
  belongs_to :user, inverse_of: :rewards_sponsors
  validates_presence_of :offer_name, :company_name, :terms_and_conditions
  validates_length_of :offer_name, minimum: 3, maximum: 50, allow_blank: false

  rails_admin do
    configure :user do
      hide
    end
  end
end
