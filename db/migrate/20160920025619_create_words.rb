class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|

      t.string   :word
      t.string   :word_plural

      t.string   :definition_en
      t.string   :definition_fr

      t.string  :gender

      t.integer  :frequency

      t.timestamps null: false
    end
  end
end
