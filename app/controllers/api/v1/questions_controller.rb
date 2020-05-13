class Api::V1::QuestionsController < Api::BaseController
  # For daily quiz question
  def daily
    render json: Question.active('daily').first
  end
  # For weekly quiz question
  def weekly
    render json: Question.active('weekly').first
  end
end
