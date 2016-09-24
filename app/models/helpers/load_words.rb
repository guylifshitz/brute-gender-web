require 'csv'    

# parsed_file = CSV.read("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6-small.csv", { :col_sep => "\t", :headers => :true });
parsed_file = CSV.read("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6.csv", { :col_sep => "\t", :headers => :true });

count = 0

words = {}

parsed_file.each do |row|
  count = count + 1
  flexion = row["Flexion"] 
  if words[flexion]
    words[flexion].append(row)
  else
    words[flexion] = [row]
  end
end

Word.destroy_all

words.each do |word|
  if word[1].count == 1

    google1grams_freq = word[1][0]["Google 1-grams"]
    wikipedia_freq = word[1][0]["Wikipédia"]
    lit_freq = word[1][0]["Littérature"]
    total_freq = word[1][0]["Total occurrences"]

    if word[1][0]["Étiquettes"] == "nom mas sg"
      Word.create({"word"=>word[0], "definition_en" => "-", "gender" => "m", "frequency" => total_freq})
    end
    if word[1][0]["Étiquettes"] == "nom fem sg"
      Word.create({"word"=>word[0], "definition_en" => "-", "gender" => "f", "frequency" => total_freq})
    end
  end
end