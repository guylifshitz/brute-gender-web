module Processing
  require 'csv'
  class BuildLevel

    def self.build_all_levels
      all_words  = Word.where.not({:frequency => nil}).order("frequency DESC")
      all_level_category = Category.create({:name=>"all", :description=>"All words"})
      
      build_level(all_words, all_level_category)
    end

    def self.build_level words, category
      level_size = words.count
      if words.count > 200
        level_size = 50
      end

      counter =0
      l = nil

      words.each do |w|
        if counter % level_size == 0
          l = Level.create({:name=>"Level #{counter/level_size + 1}", :description => "Words you'll see.", :category => category})
        end
        LevelWord.create({:level => l, :word => w})
        counter = counter + 1
      end
    end

  end
end