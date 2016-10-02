class CreateWordScores < ActiveRecord::Migration
  def change
    create_table :word_scores do |t|
      t.references :level_instance, index: true, foreign_key: true
      t.references :word, index: true, foreign_key: true

      t.boolean :correct

      t.timestamps null: false
    end
  end
end
