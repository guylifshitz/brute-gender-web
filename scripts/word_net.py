from itertools import islice
import csv


categories = {}
with open('WordNet-3.0/dict/lexnames', 'r') as csvfile:
  reader = csv.reader(csvfile, delimiter='\t')
  for row in reader:
    category_id = row[0]
    category_name = row[1]
    categories[category_id] = category_name

print(categories)

words_by_category = {}
for category in categories:
  words_by_category[category] = []

print(words_by_category)

with open('WordNet-3.0/dict/data.noun', 'r') as csvfile:
  reader = csv.reader(csvfile, delimiter=' ')
  for row in islice(reader, 29, None):
    category_id = row[1]

    word_count = row[3]
    for i in range(0,int(word_count, 16)):
      word = row[4+2*i]
      words_by_category[category_id].append(word)



output_string = ""

for category_id in categories:
  category_name = categories[category_id]
  output_string += category_name + "|"
  for word in words_by_category[category_id]:
    output_string += word + ","
  if len(words_by_category[category_id]) > 0:
    output_string = output_string[:-2]
  output_string += "\n"

output_file = open("words_categorized.txt", "w")
output_file.write(output_string)
