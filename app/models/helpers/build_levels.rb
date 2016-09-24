# load 'helpers/load_words.rb'
# load 'helpers/build_levels.rb'

level_size = 50


Level.destroy_all

all_words  = Word.order("frequency DESC")

counter = 0 
word_ids = []
all_words.each do |word|
  word_ids.append(word.id)
  counter = counter + 1
  if counter % level_size == 0
    Level.create({:name=>"Level #{counter/level_size}", :words => word_ids, :description => "Words you'll see."})
    word_ids = []
  end
end
