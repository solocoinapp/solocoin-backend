class CreateReferral < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals do |t|
    	t.string :code
    	t.float :amount
    	t.integer :referrals_count, default: 0
    	t.float :referrals_amount, default: 0.0
    	t.integer :user_id

    	t.timestamps
    end
  end
end
