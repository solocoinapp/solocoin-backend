class WalletTransaction < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :charge_session, optional: true

  enum transaction_type: [:debit, :credit]
end
