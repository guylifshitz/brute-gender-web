class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.string :description
      t.string :words, limit: 2000
      t.string :statistics

      t.timestamps null: false
    end
  end
end
