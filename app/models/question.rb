class Question < ApplicationRecord
  include RailsAdminConf

  has_many :answers, dependent: :destroy, inverse_of: :question # the questions choices

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates_presence_of :category

  scope :active, -> { where(active: true).order('RANDOM()') }

  enum category: [:daily, :weekly]
end
