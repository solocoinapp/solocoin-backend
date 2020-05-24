class UserQuestionsAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :answer
  belongs_to :user
  validates_uniqueness_of :question, scope: :user_id, message: 'User has already answered this question.'

  after_create :update_wallet

  DAILY_QUIZ_BONUS = 50
  WEEKLY_QUIZ_BONUS = 500

  private

  def update_wallet
    if question.daily? && answer.correct?
      user.wallet_balance = user.wallet_balance.to_i  + DAILY_QUIZ_BONUS
    elsif question.weekly? && answer.correct?
      user.wallet_balance.to_i  + WEEKLY_QUIZ_BONUS
    end
    user.save
  end

end
