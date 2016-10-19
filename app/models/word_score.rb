class WordScore < ActiveRecord::Base
  belongs_to :level_instance
  belongs_to :word
  belongs_to :category
  belongs_to :user
end

