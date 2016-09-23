class CreateWordScores < ActiveRecord::Migration
  def change
    create_table :word_scores do |t|

      t.references :level_instance
      t.references :user
      t.references :word

      t.boolean :correct

      t.timestamps null: false
    end
  end
end
