# brute-gender-web
Website for brute gender 

Models and Website architecture (brief)

 = USER =
  login
  register

= GENERAL = 
Welcome page
  Logged in version
  not logged in version

= LEVEL = 
Level Select Page
Level Playing Page (intro, words, finished)

= WORDS =
Word's page (word, definition in lang+fr, links to wikitonary, stats on the word success)

= ADMIN =
  Edit a word (if logged in as admin, can do this when seeing a word)
  Add words via file




Models:

User

Level (list of words)
Level order (list of words in order that they will be shown)

Words

User word scores (word + level reference)



class User < ActiveRecord::Base
  has_many :level_ran
  has_many :word_scores, :through => :level_ran
end
 
class LevelRan < ActiveRecord::Base
  belongs_to :user
  belongs_to :level
end

class Level < ActiveRecord::Base
  has_many :level_ran
end

class WordScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  belongs_to :level_ran
end

class Word < ActiveRecord::Base
  has_many :word_score
end




