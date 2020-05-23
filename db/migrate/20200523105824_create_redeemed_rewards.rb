class CreateRedeemedRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :redeemed_rewards do |t|
      t.references :user, foreign_key: true
      t.references :rewards_sponsor, foreign_key: true

      t.timestamps
    end
  end
end
