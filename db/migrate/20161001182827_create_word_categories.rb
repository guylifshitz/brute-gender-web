class CreateWordCategories < ActiveRecord::Migration
  def change
    create_table :word_categories do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
