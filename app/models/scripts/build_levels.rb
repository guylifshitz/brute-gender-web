# load 'scripts/load_words.rb'
# load 'scripts/build_levels.rb'


def build_levels_or_category words, level_category
  counter = 0 
  l = nil

  words.each do |word|
    if counter % @level_size == 0
      l = Level.create({:name=>"Level #{counter/@level_size + 1}", :description => "Words you'll see.", :level_category => level_category})
    end
    ap l
    LevelWord.create({:level => l, :word => word})
    counter = counter + 1
  end
end





@level_size = 50

ap "Destroy LevelWord..."
LevelWord.destroy_all
ap "Destroy Level..."
Level.destroy_all
ap "Destroy LevelCategory..."
LevelCategory.destroy_all

all_words  = Word.order("frequency DESC")
all_level_category = LevelCategory.create({:name=>"all", :description=>"All words"})
build_levels_or_category all_words, all_level_category




WordCategory.find_each do |wc|
  ap wc.name
  level_category = LevelCategory.create({:name=>wc.name, :description=>"-"})
  words = []

  wc.words.sort_by(&:frequency).reverse.each do |word|
    if word.word_categories.uniq == [wc]
      words.push(word)
    end
  end
  words = words.uniq
  build_levels_or_category words, level_category
end



