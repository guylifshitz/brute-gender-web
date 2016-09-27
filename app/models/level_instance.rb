class LevelInstance < ActiveRecord::Base
  serialize :words_ordered

  belongs_to :level, dependent: :destroy
  belongs_to :user, dependent: :destroy

end
