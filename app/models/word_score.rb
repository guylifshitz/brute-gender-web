class WordScore < ActiveRecord::Base
  belongs_to :level_instance
  belongs_to :word

  delegate :user, :to => :level_instance, :allow_nil => false

end

