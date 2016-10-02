}
Nokogiri::XML::Reader(File.open('scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml')).each do |node|
  if node.name == 'article' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
    NodeHandler.new(
      Nokogiri::XML(node.outer_xml).at('./article')
    ).process
  end
end


Nokogiri::XML::Reader(File.open('scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml')).each do |node|
  if node.name == 'article' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
    NodeHandlerEnglishTranslation.new(
      Nokogiri::XML(node.outer_xml).at('./article')
    ).process
  end
end





Nokogiri::XML::SAX::Parser.new(XMLParser.new).parse(File.open('scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml'))

