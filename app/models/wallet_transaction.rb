class WalletTransaction < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :charge_session, optional: true

  enum transaction_type: [:debit, :credit]

  before_create :set_identifier
  after_update_commit :update_user_wallet_balance

  private

  def set_identifier
    self.identifier = generate_identifier
  end

  def generate_identifier
    loop do
      identifier = 8.times.map{rand(10)}.join
      break identifier unless self.class.where(identifier: identifier).exists?
    end
  end

  def update_user_wallet_balance
    user.update!(wallet_balance: closing_balance)
  end
end