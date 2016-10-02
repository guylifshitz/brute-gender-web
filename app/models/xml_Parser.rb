class XMLParser < Nokogiri::XML::SAX::Document
  def start_element(name, attrs = [])
    # Handle each element, expecting the name and any attributes
    ap "==="
    ap "start_element"
    ap name
    ap attrs
    ap "==="
  end

  def characters(string)
    # Any characters between the start and end element expected as a string
    # ap "characters"
    # ap string
  end

  def end_element(name)
    # Given the name of an element once its closing tag is reached
    # ap "end_element"
  end
end
