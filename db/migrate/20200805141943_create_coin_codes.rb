class CreateCoinCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :coin_codes do |t|
      t.string :coupon_code
      t.float :amount
      t.integer :limit

      t.timestamps
    end
  end
end
