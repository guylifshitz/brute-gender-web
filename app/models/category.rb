class Category < ActiveRecord::Base
  has_many :levels
  has_many :category_words
  has_many :word_scores
end
