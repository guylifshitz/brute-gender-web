


################
# FRENCH DEFINITION
################

Nokogiri::XML::Reader(File.open('scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml')).each do |node|
  if node.name == 'article' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
    NodeHandlerFrenchDefinition.new(
      Nokogiri::XML(node.outer_xml).at('./article')
    ).process
  end
end




################
# TRANSLATIONS
################

Nokogiri::XML::Reader(File.open('scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml')).each do |node|
  if node.name == 'article' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
    NodeHandlerEnglishTranslation.new(
      Nokogiri::XML(node.outer_xml).at('./article')
    ).process
  end
end
