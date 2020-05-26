class AddOfferAmountToRewardsSponsors < ActiveRecord::Migration[5.2]
  def change
    # precision is the total number of digits
    # scale is the number of digits to the right of the decimal point
    add_column :rewards_sponsors, :offer_amount, :decimal, :precision => 8, :scale => 2
  end
end
