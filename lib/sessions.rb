module Sessions
  def self.terminate(active_session)
    active_session.update!(status: 1, end_time: Time.zone.now)
  end
end
