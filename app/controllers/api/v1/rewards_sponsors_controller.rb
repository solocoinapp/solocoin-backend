class Api::V1::RewardsSponsorsController < Api::BaseController
  before_action :validate_reward_id, :already_redeemed, only: :redeem
  # API for saving user's answer
  # GET   /api/v1/rewards_sponsors
  def index
    render json: RewardsSponsor.published
  end

  def redeem
    if current_user.wallet_balance.to_i >= @reward.coins
      current_user.redeemed_rewards.create(rewards_sponsor: @reward)
      render json: {coupon_code: @reward.coupon_code}
    else
      render_error(:unprocessable_entity, 'Insufficient coins')
    end
  end

  private

  # Ensures that the reward exists
  def validate_reward_id
    reward_id = params[:id].to_i # prevents SQL injection
    if RewardsSponsor.exists?(reward_id)
      @reward = RewardsSponsor.find(reward_id)
    else
      render_error(:unprocessable_entity, 'Reward not found')
    end
  end

  def already_redeemed
    if RedeemedReward.exists?(user: current_user, rewards_sponsor: @reward)
      render_error(:unprocessable_entity, 'Already Redeemed')
    end
  end

end
