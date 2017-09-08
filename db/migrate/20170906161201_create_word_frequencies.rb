class CreateWordFrequencies < ActiveRecord::Migration
  def change
    create_table :word_frequencies do |t|
      t.text :word
      t.integer :frequency
      t.text :pos

      t.timestamps null: false
    end
  end
end
