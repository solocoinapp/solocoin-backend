module Sessions
  module WalletTransaction
    def self.create(session)
      wallet_balance = session.user.wallet_balance
      transaction_type = session.session_type == 'home' ? 1: 0
      rewards = session.rewards
      closing_balance = wallet_balance + rewards

      session.user.wallet_transactions.create!(
        transaction_type: transaction_type,
        amount: rewards,
        closing_balance: closing_balance
      )
    end
  end
end
