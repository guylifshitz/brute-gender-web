class CreateUserWords < ActiveRecord::Migration
  def change
    create_table :user_words do |t|

      t.string :word_text
      t.string :examples, array: true, default: []
      t.references :word, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
