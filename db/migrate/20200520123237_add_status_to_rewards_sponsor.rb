class AddStatusToRewardsSponsor < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards_sponsors, :status, :integer, default: 0
    add_column :rewards_sponsors, :coins, :integer
    add_column :rewards_sponsors, :coupon_code, :string
  end
end
