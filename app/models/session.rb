class Session < ApplicationRecord
  enum status: { 'in-progress': 0, done: 1 }
  enum session_type: { home: 0, away: 1 }

  belongs_to :user

  before_update :reward
  after_update_commit :create_wallet_transaction

  def end_session
    self.end_time = Time.zone.now
    update!(status: 1)
  end

  private

  def reward
    if session_type == 'home'
      self.rewards = rewards_for_isolation
    elsif session_type == 'away'
      self.rewards = rewards_for_being_away
    end
  end

  def session_minutes
    self.start_time = Time.zone.now - 100.minutes
    ((end_time - start_time) / 1.minutes).round
  end

  def rewards_for_isolation
    (session_minutes / 10).round
  end

  def rewards_for_being_away
    -(session_minutes / 10).round * 10
  end

  def create_wallet_transaction
    user.wallet_transactions.create!(
      transaction_type: transaction_type,
      amount: rewards,
      closing_balance: closing_balance
    )
  end

  def transaction_type
    session_type == 'home' ? 1: 0
  end

  def wallet_balance
    user.wallet_balance
  end

  def closing_balance
    wallet_balance + rewards
  end
end
