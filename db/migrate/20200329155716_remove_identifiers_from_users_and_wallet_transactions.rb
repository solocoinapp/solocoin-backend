class RemoveIdentifiersFromUsersAndWalletTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :identifier
    remove_column :wallet_transactions, :identifier
  end
end
