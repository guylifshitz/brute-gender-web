class CreateUserConfigurations < ActiveRecord::Migration
  def change
    create_table :user_configurations do |t|

      t.references :user, index: true, foreign_key: true
      
      t.boolean :sound
      t.boolean :speak
      t.boolean :microphone

      t.timestamps null: false
    end
  end
end
