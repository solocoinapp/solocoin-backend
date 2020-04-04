class AddLastPingTimeOnSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :last_ping_time, :datetime, null: false
  end
end
