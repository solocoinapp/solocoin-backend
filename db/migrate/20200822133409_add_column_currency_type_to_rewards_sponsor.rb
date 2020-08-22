class AddColumnCurrencyTypeToRewardsSponsor < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards_sponsors, :currency_type, :string, default: '$'
  end
end
