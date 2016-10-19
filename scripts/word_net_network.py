import networkx as nx
import csv
from itertools import islice


words = {}

with open('WordNet-3.0/dict/data.noun', 'r') as csvfile:
  reader = csv.reader(csvfile, delimiter=' ')
  for row in islice(reader, 29, None):
    row_id = row[0]

    row_words = []
    word_count = int(row[3], 16)
    for i in range(0,word_count):
      word = row[4+2*i]
      row_words.append(word)

    word_count_offset = 4+2*word_count
    references_count = int(row[word_count_offset])

    hyper_references = []
    hypo_references = []
    meronym_references = []
    holonym_references = []

    for i in range(0,references_count):
      ref_type = row[word_count_offset + 1 + i * 4] 
      ref_address = row[word_count_offset + 2 + i * 4] 
      if ref_type == "@":
        hyper_references.append(ref_address)
      if ref_type[0] == "#" :
        holonym_references.append(ref_address)
      if ref_type == "~":
        hypo_references.append(ref_address)
      if ref_type[0] == "%":
        meronym_references.append(ref_address)
      if ref_type == "=":
        print(word)
    words[row_id] = {"words": row_words, "hyper_references": hyper_references, "holonym_references": holonym_references, "hypo_references": hypo_references, "meronym_references":meronym_references}

  # for word_id in words:
  #   word = words[word_id]
  #   print("words:")
  #   print(word["words"])
  #   print("word references:")
  #   for reference in word["references"]:
  #     print(words[reference]["words"])

def get_upwards(word_id):
  word = words[word_id]
  print("________")
  print(word["words"])

  holonym_references = word["holonym_references"]
  for word_id in holonym_references:
    print("   #" + str(words[word_id]["words"]))

  hyper_references = word["hyper_references"]
  for word_id in hyper_references:
    print("   @" + str(words[word_id]["words"]))

  references = hyper_references + holonym_references
  if references != []:
    for word_id in references:
      print_upwards(word_id)
  else:
    "END"

def get_meronyms_upwards(word_id, output_words = {}):
  if (",".join(words[word_id]["words"]) in output_words):
    return {}

  word = words[word_id]
  print("________")
  print(str(word["words"]) + "   " + str(word_id))

  # TODO: make this go up the tree to find meronyms (parts of the thing)
  meronym_references = word["meronym_references"]
  for word_id in meronym_references:
    print("   %" + str(words[word_id]["words"]))

  holonym_references = word["holonym_references"]
  for word_id in holonym_references:
    print("   #" + str(words[word_id]["words"]))

  hyper_references = word["hyper_references"]
  for word_id in hyper_references:
    print("   @" + str(words[word_id]["words"]))

  for ref_id in meronym_references + holonym_references:
    recurs_result = words[ref_id]["words"]
    output_words[",".join(words[ref_id]["words"])] = 1

  references = hyper_references + meronym_references + holonym_references
  
  if references != []:
    for ref_id in references:
      recurs_result = get_meronyms_upwards(ref_id, output_words)
      output_words.update(recurs_result)

  else:
    "END"

  return output_words

def get_downwards(word_id, output_words = {}):
  word = words[word_id]
  print("________")
  print(str(word["words"]) + "   " + str(word_id))

  output_words[",".join(word["words"])] = 1

  # TODO: make this go up the tree to find meronyms (parts of the thing)
  meronym_references = word["meronym_references"]
  for word_id in meronym_references:
    print("   %" + str(words[word_id]["words"]))

  hypo_references = word["hypo_references"]
  for word_id in hypo_references:
    print("   ~" + str(words[word_id]["words"]))

  references = hypo_references + meronym_references

  if references != []:
    for ref_id in references:
      recurs_result = get_downwards(ref_id, output_words)
      output_words.update(recurs_result)

  else:
    "END"

  return output_words

def get_parts(word_id, output_words = []):
  word = words[word_id]
  print("________")
  print(str(word["words"]) + "   " + str(word_id))

  meronym_references = word["meronym_references"]
  for word_id in meronym_references:
    print("   %" + str(words[word_id]["words"]))
    output_words.append(words[word_id]["words"])

  hyper_references = word["hyper_references"]
  for word_id in hyper_references:
    print("   @" + str(words[word_id]["words"]))

  for word_id in hyper_references:
    output_words = output_words + get_parts(word_id)

  unique_data = [list(x) for x in set(tuple(x) for x in output_words)]
  return unique_data



def build_graph():
  G=nx.Graph()
  for word_id in words:
    print(words[word_id])
    G.add_node(word_id)
  
  for word_id in words:
    references = words[word_id]["hyper_references"]
    for reference in references:
      G.add_edge(word_id,reference)

  return G

def find_id(search_word):
  returned_id = -1
  for word_id in words:
    if search_word in words[word_id]["words"]:
      print(word_id)
      print(words[word_id])
      if returned_id != -1:
        a = 1/0
      returned_id = word_id
  return returned_id

def find_ids(search_word):
  returned_id = -1
  for word_id in words:
    if search_word in words[word_id]["words"]:
      print("_____")
      print(word_id)
      print(words[word_id])

def print_word(word_id):
  word = words[word_id]
  print(word["words"])
  print("hypo_references:")
  for hypo_ref in word["hypo_references"]:
    print(str(words[hypo_ref]["words"]) + "    " + hypo_ref)
  print("hyper_references:")
  for hyper_ref in word["hyper_references"]:
    print(str(words[hyper_ref]["words"]) + "    " + hyper_ref)
  print("holonym_references:")
  for holonym_ref in word["holonym_references"]:
    print(str(words[holonym_ref]["words"]) + "    " + holonym_ref)
  print("meronym_references:")
  for meronym_ref in word["meronym_references"]:
    print(str(words[meronym_ref]["words"]) + "    " + meronym_ref)

def print_all_words(words):
  out_words = {}
  for word in words:
    print(word)
    for w in word:
      print(w)
      for w2 in w:
        print("___")
        print(w2)
        out_words[w2] = 1
  print(w2.keys())




# output_string = ""

# for category_id in categories:
#   category_name = categories[category_id]
#   output_string += category_name + "|"
#   for word in words_by_category[category_id]:
#     output_string += word + ","
#   if len(words_by_category[category_id]) > 0:
#     output_string = output_string[:-2]
#   output_string += "\n"

# output_file = open("words_categorized.txt", "w")
# output_file.write(output_string)
