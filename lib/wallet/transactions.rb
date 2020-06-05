module Wallet
  module Transactions
    def self.update_user_balance(user, new_amount)
      previous_balance = user.wallet_balance
      new_balance = if new_amount.negative? && user.wallet_balance >= new_amount.abs
        new_amount + previous_balance
      elsif new_amount.positive?
        new_amount + previous_balance
      end
      if new_amount.positive?
        total_earned_coins = user.total_earned_coins + new_amount
      end
      user.update!(wallet_balance: new_balance, total_earned_coins: total_earned_coins)
    end

    def self.update_balance_after_redeem(user, deducted_amount)
      previous_balance = user.wallet_balance.to_i
      new_balance = previous_balance - deducted_amount
      user.update!(wallet_balance: new_balance)
    end
  end
end
