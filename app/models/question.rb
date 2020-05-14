class Question < ApplicationRecord
  include RailsAdminConf

  has_many :answers, dependent: :destroy, inverse_of: :question # the questions choices
  has_many :user_questions_answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates_presence_of :category

  enum category: [:daily, :weekly]

  # It will filter the questions based on activeness and category i.e daily and weekly
  scope :active, -> { where(active: true) }
  scope :daily, -> { where(category: 0) }
  scope :weekly, -> { where(category: 1) }

  # It will only fetch those questions of user which has not been answered
  scope :not_seen, lambda { |user_id|
    joins("LEFT OUTER JOIN user_questions_answers
           ON user_questions_answers.question_id = questions.id AND
           user_questions_answers.user_id = #{user_id}")
    .where(user_questions_answers: {question_id: nil})
  }


end
