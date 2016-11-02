module Processing
  class WordSourceCounter
 
    require 'open-uri'

    def self.run category, urls
      word_counts = get_words_from_url urls
      stuff word_counts, category
    end


    def self.get_words_from_url urls
     word_counts = {}

      urls.each do |url|
        url = url.strip       
        ap "Downloading and loading the URL..."

        if url.include? "lemonde.fr"
          wiki_html = Nokogiri::HTML(open(url))
          wiki_html = Nokogiri::HTML(wiki_html.xpath("//div[@class='entry-content']").inner_html)
        elsif url.include? "wikipedia.org"
          wiki_html = Nokogiri::HTML(open(url))
          wiki_html = wiki_html.xpath("//div[@id='mw-content-text']")
        else
          wiki_html = Nokogiri::HTML(open(url))
        end


        ap "Finding paragraph words"

        wiki_words = []

        wiki_html.xpath("//p").each do |wiki_paragraph|
          p_words = wiki_paragraph.inner_text.scan /[[:alpha:]]+/
          wiki_words = wiki_words + p_words
        end

        ap "Counting words"

        wiki_words.each do |wiki_word|
          # wiki_word = wiki_word.downcase
          if word_counts[wiki_word]
            word_counts[wiki_word] = word_counts[wiki_word] + 1
          else
            word_counts[wiki_word] = 1
          end
        end

      end

      # word_counts = word_counts.sort_by{ |_key, value| value }.reverse
  
      word_counts
    end

    
    def self.stuff word_counts, category
      ap word_counts

      word_counts.keys.each do |word|
        ap word
        if word_counts[word] > 0
          w = Word.where("words.word = '#{word}' or words.word_plural = '#{word}'").first
          ap w
          if w and w[:gender] != "e" and w[:word].length > 2
            cw = CategoryWord.create()
            cw.word = w
            cw.category = category


            singular_count = 0
            singular_count = word_counts[w[:word]]
            
            plural_count = 0
            if w[:word_plural]
              if w[:word] != w[:word_plural]
                plural_count = word_counts[w[:word_plural]]
              end
            end

            word_counts[w[:word]] = -1
            word_counts[w[:word_plural]] = -1

            ap singular_count
            ap plural_count

            total_count = singular_count.to_i + plural_count.to_i

            cw.url_frequency = total_count

            if w[:frequency]
              cw.category_ranking = w[:frequency]/total_count
            else
              cw.category_ranking = 0
            end
            cw.save!
          end
        end
      end
    end

# word_score_maximum
    def self.select_included_words category
      category.category_words.each do |cw|
        if cw.word[:frequency]
          if cw.word[:frequency] < category[:word_frequency_maximum]
            cw.update_attribute(:include_word, true)
          else
            cw.update_attribute(:include_word, false)
          end
        end
      end
    end


    # def self.stuff word_category
    #   # word_category = WordCategory.where({:name => category}).first
    #   # if word_category == nil
    #   #   word_category = WordCategory.create({:name => category})
    #   # end

    #   words_added = []
    #   words_right = []
    #   words_wrong = []
    #   words_freq_none = []

    #   word_counts.each do |word|
    #     if word[1] > 1
    #       # ws = Word.where('lower(word) = ?',  word[0].downcase)
    #       # w = ws.first
    #       # if ws.count > 1
    #       #   ap "Word has two values. Most likely because one of the words had a capital letter."
    #       # end
    #       w = Word.where({:word => word[0]}).first
    #       if w
    #         if w[:frequency] < 6114831 and w[:frequency] > 0
    #           word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency], :delimiter => ','))
    #           word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency]/word[1], :delimiter => ','))
    #           word.append(w[:frequency]/word[1])
    #           word.append(w)

    #           words_added.push(word)

    #           if w[:frequency]/word[1] > 1000000
    #             words_wrong.push(word)
    #           else
    #             words_right.push(word)
    #           end

    #           w.word_categories << word_category
    #           w.save!
    #         end
    #         if w[:frequency] < 6114831 and w[:frequency] == 0
    #           word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency], :delimiter => ','))
    #           word.append(ActiveSupport::NumberHelper.number_to_delimited(w[:frequency]/word[1], :delimiter => ','))
    #           words_freq_none.push(word)
    #           words_freq_none.append(w)
    #         end
    #       end
    #     end
    #   end
    # end


    # def stuff_2 category
    #   level_category = Category.create({:name=>word_category.name, :description=>"Found from Wikipedia"})

    #   words_for_level = []

    #   words_right_sorted = words_right.sort! { |x, y| x[4] <=> y[4] }

    #   @level_size = words_right_sorted.count
    #   if words_right_sorted.count > 200
    #     @level_size = 50
    #   end

    #   counter =0
    #   l = nil

    #   words_right_sorted.each do |word|
    #     w = word[5]
    #     ap w
    #     if w[:word].length > 2
    #       if counter % @level_size == 0
    #         ap "CREATE LEVEL"
    #         l = Level.create({:name=>"Level #{counter/@level_size + 1}", :description => "Words you'll see.", :level_category => level_category})
    #       end
    #       LevelWord.create({:level => l, :word => w})
    #       counter = counter + 1
    #     end
    #   end
    # end



  end
end



  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap "words_right"
  # ap words_right
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap "words_wrong"
  # ap words_wrong
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap "words_freq_none"
  # ap words_freq_none



  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap ""
  # ap words_added.sort! { |x, y| x[4] <=> y[4] }



  # if destroy_previous
  #   ap "Destroy LevelWord..."
  #   LevelWord.destroy_all
  #   ap "Destroy WordScore..."
  #   WordScore.destroy_all
  #   ap "Destroy LevelInstance..."
  #   LevelInstance.destroy_all
  #   ap "Destroy Level..."
  #   Level.destroy_all
  #   ap "Destroy Category..."
  #   Category.destroy_all
  #   Rails.cache.clear
  # end


