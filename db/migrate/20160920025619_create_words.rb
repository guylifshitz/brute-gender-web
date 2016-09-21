class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|

      t.string   :word

      t.string   :definition_en
      t.string   :definition_fr

      t.integer  :gender

      t.timestamps null: false
    end
  end
end
