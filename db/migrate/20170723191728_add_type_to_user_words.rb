class AddTypeToUserWords < ActiveRecord::Migration
  def change
    add_column :user_words, :type, :string
  end
end
