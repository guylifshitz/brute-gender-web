class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name

      t.string :description
      t.string :statistics

      t.references :level_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
