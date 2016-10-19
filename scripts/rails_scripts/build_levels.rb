# load 'scripts/build_levels.rb'


def build_levels_for_category words, level_category
  counter = 0 
  l = nil

  words.each do |word|
    if word[:word].length > 2
      if counter % @level_size == 0
        l = Level.create({:name=>"Level #{counter/@level_size + 1}", :description => "Words you'll see.", :level_category => level_category})
      end
      LevelWord.create({:level => l, :word => word})
      counter = counter + 1
    end
  end
end





@level_size = 50

ap "Destroy LevelWord..."
LevelWord.destroy_all
ap "Destroy WordScore..."
WordScore.destroy_all
ap "Destroy LevelInstance..."
LevelInstance.destroy_all
ap "Destroy Level..."
Level.destroy_all
ap "Destroy Category..."
Category.destroy_all
Rails.cache.clear

all_words  = Word.where.not({:frequency => nil}).order("frequency DESC")
all_words = all_words
all_level_category = Category.create({:name=>"all", :description=>"All words"})
build_levels_for_category all_words, all_level_category




WordCategory.find_each do |wc|
  ap wc.name
  level_category = Category.create({:name=>wc.name, :description=>"-"})
  words = []

  wc.words.sort_by(&:frequency).reverse.each do |word|
    if word.word_categories.uniq == [wc]
      words.push(word)
    end
  end
  words = words.uniq
  build_levels_for_category words, level_category
end



