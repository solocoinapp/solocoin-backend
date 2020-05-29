class AddTotalEarnedCoinsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :total_earned_coins, :integer, default: 0
  end
end
