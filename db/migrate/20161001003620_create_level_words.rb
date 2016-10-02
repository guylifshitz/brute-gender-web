class CreateLevelWords < ActiveRecord::Migration
  def change
    create_table :level_words do |t|
      t.references :level, index: true, foreign_key: true
      t.references :word, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
