#!/usr/bin/env python
# -*- coding: utf-8 -*-


import csv
# with open('lexique-dicollecte-fr-v5.6.csv') as csvfile:
#   spamreader = csv.reader(csvfile, delimiter='\t', quotechar='|')
#   for row in spamreader:
#     print('#### '.join(row))

words = {}

count = 0

reader = csv.DictReader(open('lexique-dicollecte-fr-v5.6.csv', "r"), delimiter="\t")

words_ordered = []

for row in reader:
  count = count + 1
  print count
  if count > 100000:
    break
  try:
    words[row['Flexion']].append(row)
  except:
    words[row['Flexion']] = [row]
    words_ordered.append(row['Flexion'])

for word in words_ordered:
  if len(words[word]) == 1:
    if words[word][0]["Étiquettes"] == "nom mas sg" or words[word][0]["Étiquettes"] == "nom fem sg":
      print words[word][0]['Flexion']



  # if row["Étiquettes"] == "nom mas sg":
  #   print row