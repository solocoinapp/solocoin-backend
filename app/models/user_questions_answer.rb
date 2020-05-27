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
      ::Wallet::Transactions.update_user_balance(user, DAILY_QUIZ_BONUS)
    elsif question.weekly? && answer.correct?
      ::Wallet::Transactions.update_user_balance(user, WEEKLY_QUIZ_BONUS)
    end
  end

end
