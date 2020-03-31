module Sessions
  module Duration
    def self.in_minutes(session)
      ((session.end_time - session.start_time) / 1.minutes).round
    end
  end
end
