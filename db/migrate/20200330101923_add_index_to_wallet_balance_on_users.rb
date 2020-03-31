class AddIndexToWalletBalanceOnUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :wallet_balance, order: :desc
  end
end
