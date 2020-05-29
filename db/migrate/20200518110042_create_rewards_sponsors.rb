class CreateRewardsSponsors < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards_sponsors do |t|
      t.string :company_name
      t.string :offer_name
      t.text :terms_and_conditions
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
