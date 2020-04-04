module Sessions
  def self.terminate(active_session)
    current_time = Time.now.utc
    active_session.update!(status: 1, last_ping_time: current_time, end_time: current_time)
    active_session
  end
end
