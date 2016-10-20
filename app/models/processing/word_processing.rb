#      word_counts = word_counts = Processing::WordProcessing.get_word_frequencies_efficient

# Processing::WordProcessing.load_wikitionnary_words
# Processing::WordProcessing.add_frequencies

module Processing
  require 'csv'
  class WordProcessing

    def self.load_wikitionnary_words
      word_counts = get_word_frequencies_efficient

      CategoryWord.destroy_all
      WordScore.destroy_all
      LevelWord.destroy_all
      Word.destroy_all

      Nokogiri::XML::Reader(File.open('scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml')).each do |node|
        if node.name == 'article' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
          NodeHandlerImportWords.new(
            Nokogiri::XML(node.outer_xml).at('./article'), word_counts
          ).process
        end
      end
    end


    def self.get_word_frequencies

      debug_count = 0
      words = {}

      ap "Load file words..."

      CSV.foreach("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6.csv", { :col_sep => "\t", :headers => :true }) do |row|
        if debug_count % 10000 == 0
          ap debug_count
        end
        debug_count = debug_count + 1
        flexion = row["Flexion"]

        if flexion == flexion.downcase
          if words[flexion]
            words[flexion].append(row)
          else
            words[flexion] = [row]
          end
        end
      end;0

      word_counts = {}
      words.each do |word|
        if word[1].count == 1
          google1grams_freq = word[1][0]["Google 1-grams"]
          wikipedia_freq = word[1][0]["Wikipédia"]
          lit_freq = word[1][0]["Littérature"]
          total_freq = word[1][0]["Total occurrences"]

          if word[1][0]["Étiquettes"].include? "nom "
            word_counts[word[0]] = total_freq
          end
        end
      end;0
      word_counts
    end


    def self.get_word_frequencies_efficient

      debug_count = 0
      word_counts = {}

      ap "Load file words..."

      # TODO: find a better way to get word counts
      CSV.foreach("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6.csv", { :col_sep => "\t", :headers => :true }) do |row|
        if debug_count % 10000 == 0
          ap debug_count
        end
        debug_count = debug_count + 1
        flexion = row["Flexion"]
        total_freq = row["Total occurrences"].to_i

        if flexion == flexion.downcase
          if row["Étiquettes"].include? "nom "
            if word_counts[flexion]
              word_counts[flexion] = [total_freq, word_counts[flexion]].max
            else
              word_counts[flexion] = total_freq
            end
          end
        end
      end;0

      word_counts
    end

  end
end
