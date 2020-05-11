class Api::V1::QuestionsController < Api::BaseController
  def daily
    render json: Question.active.first
  end
end
