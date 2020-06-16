class AddRewardTypeToRewardsSponsor < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards_sponsors, :reward_type, :integer, default: 0
  end
end
