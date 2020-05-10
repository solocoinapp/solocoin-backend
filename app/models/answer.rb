class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  validates :answer_text, presence: true
end
