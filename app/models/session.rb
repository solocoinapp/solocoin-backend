class Session < ApplicationRecord
  enum status: { 'in-progress': 0, done: 1 }
  enum session_type: { home: 0, away: 1 }

  belongs_to :user
end
