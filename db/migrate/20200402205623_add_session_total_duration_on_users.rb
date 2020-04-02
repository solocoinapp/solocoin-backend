class AddSessionTotalDurationOnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :home_duration_in_seconds, :integer, null: false, default: 0
    add_column :users, :away_duration_in_seconds, :integer, null: false, default: 0
  end
end
