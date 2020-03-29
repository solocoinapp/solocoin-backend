class Session < ApplicationRecord
  enum status: { 'in-progress': 0, done: 1 }
  enum session_type: { home: 0, away: 1 }

  belongs_to :user

  before_update :reward
  after_update_commit :update_wallet_transaction

  private

  def reward
    if session_type.eql?('home')
      self.rewards = reward_for_isolation
    elsif session_type.eql?('away')
      self.rewards = reward_for_being_away
    end
  end

  def session_minutes
    self.start_time = Time.zone.now - 100.minutes
    ((end_time - start_time) / 1.minutes).round
  end

  def reward_for_isolation
    (session_minutes / 10).round
  end

  def reward_for_being_away
    -(session_minutes / 10).round * 10
  end

  def update_wallet_transaction
    transaction_type = session_type == 'home' ? 1: 0
    wallet_balance = user.wallet_balance
    closing_balance = wallet_balance + rewards
    user.wallet_transactions.create(
      transaction_type: transaction_type,
      amount: rewards,
      closing_balance: closing_balance
    )
  end
end
