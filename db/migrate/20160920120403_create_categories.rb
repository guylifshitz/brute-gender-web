class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description

      t.string :word_sources

      t.integer :word_frequency_maximum
      t.integer :word_score_maximum

      t.timestamps null: false
    end
  end
end
