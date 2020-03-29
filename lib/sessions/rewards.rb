module Sessions
  module Rewards
    def self.reward(session)
      minutes = Duration.in_minutes(session)
      rewards = calculate_rewards(session.session_type, minutes)
      session.update!(rewards: rewards)
    end

    def self.calculate_rewards(type, minutes)
      return rewards_for_isolation(minutes)  if type == 'home'

      return rewards_for_being_away(minutes) if type == 'away'

      0
    end

    def self.rewards_for_isolation(minutes)
      (minutes / 10).round
    end

    def self.rewards_for_being_away(minutes)
      -((minutes / 10).round * 10)
    end
  end
end