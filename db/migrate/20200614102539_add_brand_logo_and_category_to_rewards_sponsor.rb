class AddBrandLogoAndCategoryToRewardsSponsor < ActiveRecord::Migration[5.2]
  def change
    add_reference :rewards_sponsors, :category, foreign_key: true
    add_column :rewards_sponsors, :brand_logo, :string
  end
end
