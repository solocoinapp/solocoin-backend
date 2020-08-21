class AddCoinCodesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :coin_codes, :jsonb
  end
end
