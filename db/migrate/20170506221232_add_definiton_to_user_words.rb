class AddDefinitonToUserWords < ActiveRecord::Migration
  def change
    add_column :user_words, :definition, :text
    add_column :user_words, :example, :text
    add_column :user_words, :source_url, :string
    add_column :user_words, :source_word, :string
    add_column :user_words, :source_example, :string
  end
end
