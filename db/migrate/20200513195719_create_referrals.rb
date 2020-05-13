class CreateReferrals < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals do |t|
      t.references :referrer, index: true, foreign_key: { to_table: :users }
      t.references :candidate, index: true, foreign_key: { to_table: :users }, null: true
      t.integer :status, index: true, default: 0
      t.string :code, index: true
      t.timestamp :expires_at
      t.integer :reward
      t.timestamps
    end
  end
end
