class CreateCategoryWords < ActiveRecord::Migration
  def change
    create_table :category_words do |t|
      t.string :name
      t.string :description

      t.boolean :include_word

      t.integer :url_frequency
      t.integer :category_ranking

      t.references :word, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
