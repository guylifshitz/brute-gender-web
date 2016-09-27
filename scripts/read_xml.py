import xml.etree.ElementTree as etree
tree = etree.parse('chat.xml')
root=tree.getroot()
root


import xml.etree.ElementTree as etree
tree = etree.parse('femme.xml')
root=tree.getroot()
root

words = root.findall("article")



for word in words:
  if (word.find("text").find("pos").attrib["type"] == "nom"):
    try:
      print("---")
      print(word.find("title").text)
      print("number:", word.find("text").find("pos").attrib["number"])
      for text in word.find("text").find("pos").find("definitions").find("definition").find("gloss").find("txt").itertext():
        print(text)
      for translation in word.find("text").find("pos").find("translations").findall("trans"):
        if(translation.attrib["lang"] == "en"):
          print(translation.text)
    except: 
      pass



for text in words[1].findall("text")[0].find("pos").itertext():
  print(text)