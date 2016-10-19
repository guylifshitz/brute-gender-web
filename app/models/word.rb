class Word < ActiveRecord::Base
  serialize :definition_en

  has_many :level_words
  has_many :levels, through: :level_words

  has_many :word_scores

  has_many :category_words

end
