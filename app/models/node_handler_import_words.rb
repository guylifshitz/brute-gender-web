class NodeHandlerImportWords < Struct.new(:node, :word_counts)
  def process
    begin
      word_text = node.at("title").inner_text

      pos = node.search("pos")

      pos.each do |p|
        
        type = p.attribute("type").value
        
        if type == "nom"
          gender = p.attribute("gender").value
          number = p.attribute("number").value

           # get definition
          definition_fr = p.at("definition").at("gloss").at("txt").inner_text

          # # get translations
          translations = p.at("translations")
          english_translations = []
          if translations
            translations.search("trans").each do |trans|
              if trans.attribute("lang").value == "en"
                english_translations.push(trans.inner_text) 
              end
            end
          end

          frequency = word_counts[word_text]
          if number == "s"
            Word.create({:word=>word_text, :gender => gender, :definition_fr => definition_fr, :definition_en => english_translations, :frequency => frequency})
          elsif number == "sp"
            Word.create({:word=>word_text, :gender => gender, :definition_fr => definition_fr, :definition_en => english_translations, :frequency => frequency})
          elsif number == "p"
            # Word.create({:word=>word_text, :word_plural =>word_text, :gender => gender, :definition_fr => definition_fr, :definition_en => english_translations})
          else
            raise
          end
          break
        end
      end
      # if pos.attribute("type").value == "nom"


      #   translations = node.at("translations")

      #   english_translations = []
      #   translations.search("trans").each do |trans|
      #     if trans.attribute("lang").value == "en"
      #       english_translations.push(trans.inner_text) 
      #     end
      #   end

      #   ap english_translations

      #   if english_translations.count > 0
      #     word = Word.where({:word=>word_text}).first

      #     ap word

      #     if word
      #       word.update_attribute(:definition_en, english_translations.to_json)
      #       ap "UPDATED"
      #     else
      #       ap "!MISSING!"
      #     end
      #   end
      # end


    rescue => exception
      Rails.logger.debug "Word Creation Faild: #{word_text}"
      Rails.logger.debug exception

    end
  end
end


