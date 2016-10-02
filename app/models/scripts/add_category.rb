# load 'scripts/add_category.rb'

# Some stats:
# based on a subsample we had the following distribution of words:
#   A middle sample:
#     No categories:  6710
#     1  categories:  6871
#     2+ categories:  1418
#
#   A later sample (more rare words): 
#     No categories:  26237
#     1  categories:  9662
#     2+ categories:  1534
#
#   * more frequent words have more categories.
#

file = File.read("scripts/words_categorized.txt");

lines = file.split("\n");

categories = {}
words_categorized = {}

lines.each do |line|
  line_parts = line.split("|")
  category = line_parts[0]
  if line_parts.count > 1
    words = line_parts[1].split(",")
    categories[category] = words
    
    words.each do |word|
      words_categorized[word] = category
    end

  end
end


Word.where.not({:definition_en => nil}).find_each do |word|
  ap "-------"
  ap word
  # TODO change this to serialie from json
  JSON.parse(word[:definition_en]).each do |translation|
    ap translation
    if words_categorized[translation]
      
      word_category = WordCategory.where({:name => words_categorized[translation]}).first
      if word_category == nil
        word_category = WordCategory.create({:name => words_categorized[translation]})
      end

      ap "word_category:"
      ap word_category

      word.word_categories << word_category
      word.save!

      ap "word.word_categories: "
      ap word.word_categories

    end
  end
end




Word.where("categories ilike '%\n- noun.object\n%'")