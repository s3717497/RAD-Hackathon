class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :question_id
      t.string :title
      t.string :description
      t.boolean :multiple_correct_answers
      t.text :explanation
      t.string :difficulty
      t.string :category

      t.timestamps
    end
  end
end
