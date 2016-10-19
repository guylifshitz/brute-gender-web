# load 'scripts/get_wikipedia_word.rb'

destroy_previous = false
# category = "Bicyclette"
# category = "Boulangerie"
# category = "Pain_au_chocolat"
category = "Pain"
# categories = ["Boulangerie", "Quiche", "Baguette", "Baguette_(pain)", ]

require 'open-uri'


wiki_html = Nokogiri::HTML(open("https://fr.wikipedia.org/wiki/#{category}"))
# wiki_html = Nokogiri::HTML(open("https://fr.wikipedia.org/wiki/Oiseau"))
wiki_html = wiki_html.xpath("//div[@id='mw-content-text']")

wiki_words = []

wiki_html.xpath("//p").each do |wiki_paragraph|
  p_words = wiki_paragraph.inner_text.scan /[[:alpha:]]+/
  wiki_words = wiki_words + p_words
end


word_counts = {}
wiki_words.each do |wiki_word|
  wiki_word = wiki_word.downcase
  if word_counts[wiki_word]
    word_counts[wiki_word] = word_counts[wiki_word] + 1
  else
    word_counts[wiki_word] = 1
  end
end

word_counts = word_counts.sort_by{ |_key, value| value }.reverse

ap word_counts

word_category = WordCategory.where({:name => category}).first
if word_category == nil
  word_category = WordCategory.create({:name => category})
end


words_added = []
words_right = []
words_wrong = []
words_freq_none = []

word_counts.each do |word|
  if word[1] > 1
    # ws = Word.where('lower(word) = ?',  word[0].downcase)
    # w = ws.first
    # if ws.count > 1
    #   ap "Word has two values. Most likely because one of the words had a capital letter."
    # end
    w = Word.where({:word => word[0]}).first
    if w
      if w[:frequency] < 6114831 and w[:frequency] > 0
        word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency], :delimiter => ','))
        word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency]/word[1], :delimiter => ','))
        word.append(w[:frequency]/word[1])
        word.append(w)

        words_added.push(word)

        if w[:frequency]/word[1] > 1000000
          words_wrong.push(word)
        else
          words_right.push(word)
        end

        w.word_categories << word_category
        w.save!
      end
      if w[:frequency] < 6114831 and w[:frequency] == 0
        word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency], :delimiter => ','))
        word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency]/word[1], :delimiter => ','))
        words_freq_none.push(word)
        words_freq_none.append(w)
      end
    end
  end
end

ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap "words_right"
ap words_right
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap "words_wrong"
ap words_wrong
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap "words_freq_none"
ap words_freq_none



ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap ""
ap words_added.sort! { |x, y| x[4] <=> y[4] }



if destroy_previous
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
end

level_category = Category.create({:name=>word_category.name, :description=>"Found from Wikipedia"})

words_for_level = []

words_right_sorted = words_right.sort! { |x, y| x[4] <=> y[4] }

@level_size = words_right_sorted.count
if words_right_sorted.count > 200
  @level_size = 50
end

counter =0
l = nil

words_right_sorted.each do |word|
  w = word[5]
  ap w
  if w[:word].length > 2
    if counter % @level_size == 0
      ap "CREATE LEVEL"
      l = Level.create({:name=>"Level #{counter/@level_size + 1}", :description => "Words you'll see.", :level_category => level_category})
    end
    LevelWord.create({:level => l, :word => w})
    counter = counter + 1
  end
end

