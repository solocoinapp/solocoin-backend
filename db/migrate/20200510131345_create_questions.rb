class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.text :question_text
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
