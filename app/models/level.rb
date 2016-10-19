class Level < ActiveRecord::Base

  belongs_to :category

  has_many  :level_words
  has_many  :words, through: :level_words
  
  has_many  :level_instances
  
end