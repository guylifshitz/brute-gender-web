This project is a ruby on rails website that provides a way to practice and improve on a user's french gender knowledge.

The website is not hosted yet.




TODO:
+ Statistics at end of level
+ Make level from words you got wrong 
+ Add definitions
+ Show level completness on level screen
+ Make levels based on category
+ Filters on word list (words you got right, wrong, seen often, etc...)
+ Level descriptions should be based on what they are
+ Randomize the level instances' word order
+ 




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
