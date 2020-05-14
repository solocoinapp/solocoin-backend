class Api::V1::QuestionsController < Api::BaseController
  # For daily quiz question
  def daily
    render json: Question.active.daily.not_seen(@api_current_user.id).first
  end
  # For weekly quiz question
  def weekly
    render json: Question.active.weekl.not_seen(@api_current_user.id).first
  end
end
