class Question < ApplicationRecord
  include RailsAdminConf

  has_many :answers, dependent: :destroy, inverse_of: :question # the questions choices

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :question_text, presence: true, uniqueness: true

end
