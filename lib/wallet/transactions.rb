module Wallet
  module Transactions
    def self.update_user_balance(user, new_amount)
      previous_balance = user.wallet_balance
      new_balance = new_amount + previous_balance
      user.update!(wallet_balance: new_balance)
    end
  end
end
