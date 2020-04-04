class Session < ApplicationRecord
  enum status: { 'in-progress': 0, done: 1 }
  enum session_type: { home: 0, away: 1 }

  PING_INTERVAL_IN_MINUTES = 10

  belongs_to :user

  def extend_ping
    update_attribute(:last_ping_time, Time.now.utc)
  end
end
