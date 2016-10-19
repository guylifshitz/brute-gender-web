class AddParametersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sound, :boolean
    add_column :users, :microphone, :boolean
  end
end
