class CreateLevelInstances < ActiveRecord::Migration
  def change
    create_table :level_instances do |t|
      t.references :level
      t.references :user
      t.string :words_ordered
      t.integer :count
    end
  end
end
