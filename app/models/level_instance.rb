class LevelInstance < ActiveRecord::Base
  belongs_to :level
  belongs_to :user

  has_many :word_scores
end
