class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  validates :name, presence: true
end
