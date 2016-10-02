class NodeHandlerEnglishTranslation < Struct.new(:node)
  def process
    begin
      word_text = node.at("title").inner_text


      ap "---"

      pos = node.at("pos")
      if pos.attribute("type").value == "nom"
        translations = node.at("translations")

        english_translations = []
        translations.search("trans").each do |trans|
          if trans.attribute("lang").value == "en"
            english_translations.push(trans.inner_text) 
          end
        end

        ap english_translations

        if english_translations.count > 0
          word = Word.where({:word=>word_text}).first

          ap word

          if word
            word.update_attribute(:definition_en, english_translations.to_json)
            ap "UPDATED"
          else
            ap "!MISSING!"
          end
        end
      end



    rescue
      ap "FAILED: "
      ap word_text
    end
  end
end


