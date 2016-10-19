This project is a ruby on rails website that provides a way to practice and improve on a user's french gender knowledge.

The website is not hosted yet.




TODO:
+ Add option to add words to the practice list from the level word list.
+ Add plurals
+ Statistics at end of level
+ Filters on word list (words you got right, wrong, seen often, etc...)
+ ??? Randomize the level instances' word order ???


CATEGORY TODO:
+ Make level from the scanned words
+ Consider plurals the same as singular in count
+ Don't count words with Capital letters at start which don't have a period before (filters out proper names)


Models:


LevelCategory
  has_many    ~LevelCategoryJoin
  has_many_t  Level           through: LevelCategoryJoin

Level
  has_many    ~LevelCategoryJoin
  has_many    ~LevelWordJoin
  has_many_t  LevelCategory   through: LevelCategoryJoin
  has_many_t  word            through: LevelWordJoin
  has_many    LevelInstance

LevelInstance
  has_many    WordScore
  has_many_t  Word            through: WordScore
  belongs_to  Level
  belongs_to  User

WordScore
  belongs_to  LevelInstance
  belongs_to  Word
  delegate :user, :to => :LevelInstance, :allow_nil => false

User
  has_many    LevelInstance
  has_many_t  WordScore       through: LevelInstance

Word
  has_many    ~LevelWordJoin
  has_many    WordScore
  has_many    WordCategory
  has_many_t  Level           through: LevelWordJoin

WordCategory
  has_many    Word

WordWordCategory
  belongs_to  Word
  belongs_to  WordCategory

LevelCategoryJoin
  belongs_to  Level
  belongs_to  LevelCategory

LevelWordJoin
  belongs_to  Level
  belongs_to  Word
