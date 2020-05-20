class RewardsSponsor < ApplicationRecord
  include RewardsSponsorsRailsAdminConf

  belongs_to :user, inverse_of: :rewards_sponsors
  validates_presence_of :offer_name, :company_name, :terms_and_conditions
  validates_length_of :offer_name, minimum: 3, maximum: 50, allow_blank: false
  before_create :set_status

  enum status: [:draft, :published]

  scope :published, -> { where(status: :published) }

  private

  def set_status
    self.status = :draft
  end
end
