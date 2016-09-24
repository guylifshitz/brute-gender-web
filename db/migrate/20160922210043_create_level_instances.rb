class CreateLevelInstances < ActiveRecord::Migration
  def change
    create_table :level_instances do |t|
      t.references :level
      t.references :user
      t.string :words_ordered, limit: 2000
      t.integer :count
    end
  end
end
