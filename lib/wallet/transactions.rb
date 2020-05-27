module Wallet
  module Transactions
    def self.update_user_balance(user, new_amount)
      previous_balance = user.wallet_balance
      new_balance = new_amount + previous_balance
      total_earned_coins = user.total_earned_coins + new_amount
      user.update!(wallet_balance: new_balance, total_earned_coins: total_earned_coins)
    end
  end
end
