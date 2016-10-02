class CreateWordCategoriesWords < ActiveRecord::Migration
  def change
    create_table :word_categories_words do |t|
      t.references :word, index: true, foreign_key: true
      t.references :word_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
