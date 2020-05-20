class AddStatusToRewardsSponsor < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards_sponsors, :status, :integer, default: 0
  end
end
