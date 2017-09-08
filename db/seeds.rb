# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create! :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
UserConfiguration.create({:user => user, :sound => true, :speak => true, :microphone => true})

# load 'scripts/load_words.rb'
# load 'scripts/build_levels.rb'

# LoadWiktionnaryWordsWorker.perform_async




# w1 = Word.create({:word => "apple" , :definition_fr => "a round fruit"})
# w2 = Word.create({:word => "orange" , :definition_fr => "a orange fruit"})
# w3 = Word.create({:word => "grape" , :definition_fr => "a green or red fruit"})
# w4 = Word.create({:word => "lemon" , :definition_fr => "a yellow fruit"})

# cat = Category.create({:name => "fruits"})

# cw1 = CategoryWord.create({:word => w1, :category => cat, :url_frequency => 100, :category_ranking => 30, :include_word => true })
# cw2 = CategoryWord.create({:word => w2, :category => cat, :url_frequency => 200, :category_ranking => 50, :include_word => true })
# cw3 = CategoryWord.create({:word => w3, :category => cat, :url_frequency => 40, :category_ranking => 150, :include_word => true })
# cw4 = CategoryWord.create({:word => w4, :category => cat, :url_frequency => 20, :category_ranking => 110, :include_word => false })

# l1 = Level.create({:category => cat, :name => "Fruits!!!", :description => "a level about fruits"})
# l2 = Level.create({:category => cat, :name => "Fruits !2!", :description => "another level about fruits"})

# LevelWord.create({:level => l1, :word => cw1.word})
# LevelWord.create({:level => l1, :word => cw2.word})
# LevelWord.create({:level => l2, :word => cw3.word})
# LevelWord.create({:level => l2, :word => cw4.word})

