class QuestionSerializer < ApplicationSerializer
  attributes :id, :name
  has_many :answers, serializer: AnswerSerializer
end
