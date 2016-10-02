class NodeHandlerFrenchDefinition < Struct.new(:node)
  def process
    begin
      word_text = node.at("title").inner_text

      pos = node.at("pos")
      if pos.attribute("type").value == "nom"
        definition_fr = node.at("definition").at("gloss").at("txt").inner_text
        word = Word.where({:word=>word_text}).first

        if word
          word.update_attribute(:definition_fr, definition_fr)
        else
          ap "!MISSING!"
        end
      
      end

    rescue
      ap "FAILED: "
      ap word_text
    end
  end
end


