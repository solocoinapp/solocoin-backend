class Api::V1::UsersController < Api::BaseController
  before_action :validate_reward_id, :already_redeemed, only: :redeem_rewards

  def show
    render json: current_user
  end

  def update
    current_user.update!(user_params)
    render json: current_user
  end

  def redeem_rewards
    if current_user.wallet_balance.to_i >= @reward.coins
      current_user.redeemed_rewards.create(rewards_sponsor: @reward)
      render json: {coupon_code: @reward.coupon_code}
    else
      render_error(:unprocessable_entity, 'Insufficient coins')
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :mobile, :profile_picture, :lat, :lng)
  end

  # Ensures that the reward exists
  def validate_reward_id
    reward_id = params[:rewards_sponsor_id].to_i # prevents SQL injection
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
