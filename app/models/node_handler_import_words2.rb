class NodeHandlerImportWords2 < Struct.new(:node, :word_counts)
  
  def get_paradigms pos
      ret_inflections = {}
      begin
            paradigm = pos.at("paradigm")
            inflections = paradigm.search("inflection")
            inflections = inflections + paradigm.search("equivFem")
            inflections = inflections + paradigm.search("equivMasc")
            inflections.each do |inflection|
                  gracePOS = inflection.attribute("gracePOS").value
                  value = inflection.attribute("form").value
                  ret_inflections[gracePOS] = value
            end
      rescue
      end

      ret_inflections
  end

  def get_definitions pos
      definitions = []
      begin
            pos.at("definitions").search("definition").each do |definition|
                  def_text = definition.at("gloss").at("txt").inner_text

                  labels = definition.search("label")
                  ret_labels = {}
                  if labels
                        labels.each do |label|
                              type = label.attribute("type").value 
                              value = label.attribute("value").value
                              ret_labels[type] = value
                        end
                  end

                  examples = []
                  definition.xpath("example").each do |example|
                        examples.append(example.at("txt").inner_text)
                  end

                  definitions.append({"definition": def_text, "labels": ret_labels, "examples": examples})
            end
      rescue
      end
      definitions
  end

  def get_translations(pos)
      ret_translations = {}
      begin
            translations = pos.at("translations")

            if translations
                  translations.search("trans").each do |trans|
                        lang = trans.attribute("lang").value
                        value = trans.inner_text
                        ret_translations[lang] = value
                  end
            end
      rescue
      end
      ret_translations
  end


  def get_morphos(pos)
      morphos = {}
      begin
            morpho_fields = pos.xpath("subsection[@type='morpho']/item")
            morpho_fields.each do |morpho_field|
                  type = morpho_field.attribute("type").value
                  if morphos[type]
                        morphos[type] = morphos[type] + [morpho_field.inner_text]
                  else
                        morphos[type] = [morpho_field.inner_text]
                  end
            end
      rescue
      end

      morphos

  end

  def get_alternativeForm(pos)
      alternative_forms = []
      alternative_form_fields = pos.xpath("subsection[@type='alternativeForm']/item")

      alternative_form_fields.each do |alternative_form_field|
            alternative_forms.append(alternative_form_field.inner_text)
      end
      alternative_forms
  end

  def get_semRel(pos)
      sem_rels = {}
      begin
            sem_rel_fields = pos.xpath("subsection[@type='semRel']/item")
            sem_rel_fields.each do |sem_rel_field|
                  type = sem_rel_field.attribute("type").value
                  if sem_rels[type]
                        sem_rels[type] = sem_rels[type] + [sem_rel_field.inner_text]
                  else
                        sem_rels[type] = [sem_rel_field.inner_text]
                  end
            end
      rescue
      end

      sem_rels

  end



  def process
    cur_pos = nil
    begin
      # ap node
      word_text = node.at("title").inner_text

      pos = node.search("pos")
      # ap pos
      pos.each do |p|
            cur_pos = p
            type = p.attribute("type").value
            lemma = p.attribute("lemma").value
            locution = p.attribute("locution").value

            if lemma == "1" and locution == "0"
                  # ap "-------"
                  # ap "-------"
                  # ap "-------"
                  # ap "-------"
                  # ap "-------"
                  # ap "-------"
                  # ap word_text

                  definitions = get_definitions(pos)
                  paradigms = get_paradigms(pos)
                  translations = get_translations(pos)
                  semantic_relations = get_semRel(pos)
                  morphos = get_morphos(pos)
                  alternative_forms = get_alternativeForm(pos)

                  if type == "nom"
                        # gender = p.attribute("gender").value
                        # number = p.attribute("number").value
                        # ap gender
                        # ap number
                  end

                  if type == "verbe"
                        # ap "verbe"
                        # ap p.attributes
                        # gender = p.attribute("gender").value
                        # number = p.attribute("number").value
                        # ap gender
                        # ap number
                  end

                  if type == "adverbe"
                        # ap "adverbe"
                        # ap p.attributes
                        # gender = p.attribute("gender").value
                        # number = p.attribute("number").value
                        # ap gender
                        # ap number
                  end

                  if type == "adjective"
                        # ap "adjective"
                        # ap p.attributes
                        # gender = p.attribute("gender").value
                        # number = p.attribute("number").value
                        # ap gender
                        # ap number
                  end

                  Word.create({:word => word_text, :word_type => type, :locution => (locution == "1"), :definitions => definitions, :translations => translations,
                   :semantic_relations => semantic_relations, :morphos => morphos, :alternative_forms => alternative_forms}.merge(paradigms))


            end


      end

            # if type == "verb"
            #       # gender = p.attribute("gender").value
            #       # number = p.attribute("number").value
            # end

            # if type == "adjective"
            #       # gender = p.attribute("gender").value
            #       # number = p.attribute("number").value
            # end

            # if type == "adverbe"
            #       # gender = p.attribute("gender").value
            #       # number = p.attribute("number").value
            # end

      # end
 
      #   if type == "nom"
      #     gender = p.attribute("gender").value
      #     number = p.attribute("number").value

      #      # get definition
      #     definition_fr = p.at("definition").at("gloss").at("txt").inner_text

      #     # # get translations
      #     translations = p.at("translations")
      #     english_translations = []
      #     if translations
      #       translations.search("trans").each do |trans|
      #         if trans.attribute("lang").value == "en"
      #           english_translations.push(trans.inner_text) 
      #         end
      #       end
      #     end

      #     frequency = word_counts[word_text]
      #     if number == "s"
      #       w = Word.where({:word => word_text}).first
      #       if w
      #         w.update_attributes({:gender => gender, :definition_fr => definition_fr, :definition_en => english_translations, :frequency => frequency})
      #       else
      #       end
      #     elsif number == "sp"
      #       Word.create({:word => word_text, :word_plural => word_text, :gender => gender, :definition_fr => definition_fr, :definition_en => english_translations, :frequency => frequency})
      #     elsif number == "p"
      #       word_plural = word_text
      #       word_singular = definition_fr.sub!("Pluriel de ", "")
      #       word_singular = definition_fr.sub!(".", "")

      #       w = Word.where({:word => word_singular}).first
      #       if w
      #         w.update_attribute(:word_plural, word_plural)
      #       else
      #         Word.create({:word => word_singular, :word_plural => word_plural})
      #       end
      #     else
      #       raise
      #     end
      #     break
      #   end
      # end
      # if pos.attribute("type").value == "nom"


      #   translations = node.at("SublimeANSItranslations")

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
      Rails.logger.debug exception.backtrace.join("\n")
      Rails.logger.debug cur_pos
    end
  end
end


