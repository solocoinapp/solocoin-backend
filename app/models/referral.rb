class Referral < ApplicationRecord
  CODE_PREFIX = 'STAYHOME'.freeze
  REWARD_VALUE = 1000

  enum status: { pending: 0, rewarded: 1 }

  scope :for_candidate, ->(user) { where(candidate_id: user.id) }
  scope :for_referrer, ->(user) { where(referrer_id: user.id) }

  before_create :generate_code

  private

  def generate_code
    new_code = "#{CODE_PREFIX}-#{SecureRandom.hex[0, 4].upcase}"

    if Referral.exists?(referrer_id: referrer_id, code: new_code)
      generate_code
    else
      self.code = new_code
      self.reward = REWARD_VALUE
    end
  end
end
