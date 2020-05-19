class Api::V1::UserQuestionsAnswersController < Api::BaseController
  before_action :validate_question_id
  # API for saving user's answer
  # POST   /api/v1/carts/:cart_id/cart_items
  # body ex:
  # {
  #   "question_id": 2,
  #   "answer_id": 1,
  # }
  def create
    question = Question.find(@question_id)
    user_answer = question.user_questions_answers.create(answer_id: user_questions_answer_params[:answer_id],
                                                         user_id: current_user.id)
    if user_answer.valid?
      render json: {}, status: :created
    else
      render_error(:unprocessable_entity, user_answer.errors.full_messages.to_sentence)
    end
  end

  private

  def user_questions_answer_params
    params.require(:user_questions_answer).permit(:question_id, :answer_id)
  end

  # Ensures that the question exists
  def validate_question_id
    @question_id = user_questions_answer_params[:question_id].to_i # prevents SQL injection
    render_error(:unprocessable_entity, 'Question not found') unless Question.exists?(@question_id)
  end
end
