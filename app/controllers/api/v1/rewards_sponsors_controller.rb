class Api::V1::RewardsSponsorsController < Api::BaseController
  # API for saving user's answer
  # GET   /api/v1/rewards_sponsors
  def index
    render json: RewardsSponsor.published
  end
end
