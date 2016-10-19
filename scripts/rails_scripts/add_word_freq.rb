# load 'scripts/add_word_freq.rb'

# TODO: 
#   consider using the ID numbers in the lexical file and consider cases where more than one word for same spelling. 
#   (Maybe it will help with frequency.)
#       OR
#   maybe change this to wikitionary and just use the frequency values from the lexique-dicollecte file

require 'csv'    

ap "Load file..."
# parsed_file = CSV.read("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6-small.csv", { :col_sep => "\t", :headers => :true });
parsed_file = CSV.read("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6.csv", { :col_sep => "\t", :headers => :true });

count = 0

words = {}

ap "Load file words..."

parsed_file.each do |row|
  if count % 1000 == 0
    ap count
  end
  count = count + 1
  flexion = row["Flexion"] 
  if words[flexion]
    words[flexion].append(row)
  else
    words[flexion] = [row]
  end
end;0



words.each do |word|
  if word[1].count == 1
    google1grams_freq = word[1][0]["Google 1-grams"]
    wikipedia_freq = word[1][0]["Wikipédia"]
    lit_freq = word[1][0]["Littérature"]
    total_freq = word[1][0]["Total occurrences"]

    if word[1][0]["Étiquettes"].include? "nom "
      if Word.where({:word => word[0]}).count > 1
        raise "Word cound shouldn't be more than 1 (#{word[0]}"
      end

      w = Word.where({:word => word[0]}).first
      if w
        w.update_attribute(:frequency, total_freq)
      end
    end
  end
end;0
