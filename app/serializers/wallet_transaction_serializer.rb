class WalletTransactionSerializer < ApplicationSerializer
  attributes :id, :description, :amount, :transaction_type, :timestamp, :closing_balance
end
