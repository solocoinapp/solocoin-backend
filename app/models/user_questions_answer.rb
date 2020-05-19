class UserQuestionsAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :answer
  belongs_to :user
  validates_uniqueness_of :question, scope: :user_id, message: 'User has already answered this question.'
end
