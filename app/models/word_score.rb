class WordScore < ActiveRecord::Base
  belongs_to :level_instance, dependent: :destroy
  belongs_to :user, dependent: :destroy
  belongs_to :word, dependent: :destroy
end

