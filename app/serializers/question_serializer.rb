class QuestionSerializer < ApplicationSerializer
  attributes :name
  has_many :answers, serializer: AnswerSerializer
end
