class RedeemedReward < ApplicationRecord
  belongs_to :user
  belongs_to :rewards_sponsor
  after_create :update_wallet#, :wallet_transactions # need to confirm about this

  private

  def update_wallet
    user.wallet_balance = user.wallet_balance.to_i  - rewards_sponsor.coins
    user.save
  end
end
