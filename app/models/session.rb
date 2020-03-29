class Session < ApplicationRecord
  enum status: { 'in-progress': 0, done: 1 }
  enum session_type: { home: 0, away: 1 }

  belongs_to :user

  before_update :reward

  private

  def reward
    if session_type.eql?('home')
      self.rewards = reward_for_isolation
    elsif session_type.eql?('away')
      self.rewards = reward_for_being_away
    end
  end

  def session_minutes
    ((end_time - start_time) / 1.minutes).round
  end

  def reward_for_isolation
    (session_minutes / 10).round
  end

  def reward_for_being_away
    -(session_minutes / 10).round * 10
  end
end
