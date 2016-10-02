class CreateLevelInstances < ActiveRecord::Migration
  def change
    create_table :level_instances do |t|
      t.references :level, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.integer :complete_count
      t.float :correct_completion_percent

      t.timestamps null: false
    end
  end
end
