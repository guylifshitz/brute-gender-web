# word_counts = Processing::WordProcessing.get_word_frequencies_efficient
# Processing::WordProcessing.load_wikitionnary_words
# Processing::WordProcessing.add_frequencies

module Processing
  require 'csv'
  class WordProcessing

    def self.load_wikitionnary_words
      word_counts = []
      word_counts = get_word_frequencies_ngrams
      ActiveRecord::Base.logger = nil

      CategoryWord.destroy_all
      WordScore.destroy_all
      LevelWord.destroy_all
      Word.destroy_all
      # Pos.destroy_all

      Nokogiri::XML::Reader(File.open('scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml')).each do |node|
      # Nokogiri::XML::Reader(File.open('scripts/une.xml')).each do |node|
        if node.name == 'article' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
          NodeHandlerImportWords2.new(
            Nokogiri::XML(node.outer_xml).at('./article'), word_counts
          ).process
        end
      end

      Processing::BuildLevel.build_all_levels

    end


    def self.get_word_type word
      word_types = ["ADJ", "DET", "ADV", "PRON", "VERB", "ADP", "CONJ", "NOUN", "PRT"]
      word_types.each do |word_type|
        if word.end_with?(word_type)
          word = word[0..word.index(word_type)-2]
          return [word, word_type.downcase]
        end
      end
      return [word, "LEMMA".downcase]
    end
    
    def self.get_word_frequencies_original

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


    def self.get_word_frequencies_ngrams

      debug_count = 0
      word_counts = {}

      ap "Load frequencies..."
      # TODO: find a better way to get word counts
      CSV.foreach("#{Rails.root}/scripts/word_counts_ngrams.csv", { :col_sep => "\t", :headers => :true }) do |row|
        begin
          if debug_count % 100000 == 0
            ap debug_count
          end
          debug_count = debug_count + 1
          
          # if debug_count > 1000000
            # return word_counts
          # end

          count = row["count"].to_i
          word = row["word"]
          word, type = get_word_type(word)
          
          word_counts[word] = word_counts[word].to_h.merge( { type => count } )

        rescue
          ap "Failed on word : " 
          ap row
        end
      end;0
      word_counts
    end


    def self.import_word_frequencies
      ActiveRecord::Base.logger = nil

      debug_count = 0

      ap "Delete existing frequencies..."
      WordFrequency.delete_all
      
      ap "Load frequencies..."
      word_frequencies=[] 
      # TODO: find a better way to get word counts
      CSV.foreach("#{Rails.root}/scripts/word_counts_ngrams.csv", { :col_sep => "\t", :headers => :true }) do |row|
        begin
          if debug_count % 100000 == 0
            ap debug_count
            WordFrequency.import word_frequencies
            word_frequencies = []
          end
          debug_count = debug_count + 1
          count = row["count"].to_i
          word = row["word"]
          word, type = get_word_type(word)
          w = WordFrequency.new(:word=>word, :pos=>type, :frequency => count)
          word_frequencies.append(w)
        rescue
          ap "Failed on word : " 
          ap row
        end
      end;0
    end
  end
end
