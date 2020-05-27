class RedeemedReward < ApplicationRecord
  belongs_to :user
  belongs_to :rewards_sponsor
  after_create :update_wallet#, :wallet_transactions # need to confirm about this

  private

  def update_wallet
    ::Wallet::Transactions.update_balance_after_redeem(user, rewards_sponsor.coins)
  end
end
