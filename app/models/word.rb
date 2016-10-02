class Word < ActiveRecord::Base
  serialize :definition_en

  has_many :level_words
  has_many :levels, through: :level_words

  has_many :word_scores

  has_and_belongs_to_many :word_categories

end
