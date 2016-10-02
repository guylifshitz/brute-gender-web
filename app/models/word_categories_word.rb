class WordCategoriesWord < ActiveRecord::Base
  belongs_to :words
  belongs_to :word_categories
end
