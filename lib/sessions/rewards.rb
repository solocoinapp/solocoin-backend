module Sessions
  module Rewards
    def self.reward(session)
      minutes = Duration.in_minutes(session)
      rewards = calculate(session.session_type, minutes)
      session.update!(rewards: rewards)
    end

    def self.calculate(type, minutes)
      return for_isolation(minutes)  if type == 'home'

      return for_being_away(minutes) if type == 'away'

      0
    end

    def self.for_isolation(minutes)
      (minutes / 10).round
    end

    def self.for_being_away(minutes)
      -((minutes / 10).round * 10)
    end
  end
end
