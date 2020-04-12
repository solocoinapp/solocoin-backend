module Sessions
  module Rewards
    REWARDS_PER_MIN = 1
    PENALTY_PER_MIN = 10

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
      (minutes * REWARDS_PER_MIN).round
    end

    def self.for_being_away(minutes)
      -(minutes * PENALTY_PER_MIN).round
    end
  end
end
