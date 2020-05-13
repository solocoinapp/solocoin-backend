class CreateUserQuestionsAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_questions_answers do |t|
      t.references :question, foreign_key: true, index: true
      t.references :answer, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
