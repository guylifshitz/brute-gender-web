# load 'scripts/load_words.rb'

require 'csv'    

ap "Load file..."
parsed_file = CSV.read("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6-small.csv", { :col_sep => "\t", :headers => :true });
# parsed_file = CSV.read("#{Rails.root}/scripts/lexique-dicollecte-fr-v5.6.csv", { :col_sep => "\t", :headers => :true });

count = 0

words = {}

ap "Load file words..."

parsed_file.each do |row|
  count = count + 1
  flexion = row["Flexion"] 
  if words[flexion]
    words[flexion].append(row)
  else
    words[flexion] = [row]
  end
end

ap "Destroy old words..."
Word.destroy_all

ap "Create new words (singular and invariable)..."
words.each do |word|
  if word[1].count == 1
    google1grams_freq = word[1][0]["Google 1-grams"]
    wikipedia_freq = word[1][0]["Wikipédia"]
    lit_freq = word[1][0]["Littérature"]
    total_freq = word[1][0]["Total occurrences"]
  else
    google1grams_freq = -1
    wikipedia_freq = -1
    lit_freq = -1
    total_freq = -1
  end

  case word[1][0]["Étiquettes"]
  when "nom mas sg"
    Word.create({"word"=>word[0], "gender" => "m", "frequency" => total_freq})
  when "nom fem sg"
    Word.create({"word"=>word[0], "gender" => "f", "frequency" => total_freq})
  when "nom mas inv"
    Word.create({"word"=>word[0], "gender" => "m", "frequency" => total_freq, "word_plural" => word[0]})
  when "nom fem inv"
    Word.create({"word"=>word[0], "gender" => "f", "frequency" => total_freq, "word_plural" => word[0]})
  end

end


ap "Add plurals to existing words..."
words.each do |word|
  if word[1].count == 1
    google1grams_freq = word[1][0]["Google 1-grams"]
    wikipedia_freq = word[1][0]["Wikipédia"]
    lit_freq = word[1][0]["Littérature"]
    total_freq = word[1][0]["Total occurrences"]
  else
    google1grams_freq = -1
    wikipedia_freq = -1
    lit_freq = -1
    total_freq = -1
  end

  lemme = word[1][0]["Lemme"]

  gender = nil

  word[1].each do |w|
    case w["Étiquettes"]
    when "nom mas pl"
      gender = "m"
    when "nom fem pl"
      gender = "f"
    end
  end

  if gender != nil
    ap word
    ap Word.where({"word"=>lemme, "gender" => gender})

    if Word.where({"word"=>lemme, "gender" => gender}).count == 0
      ap "No words in the DB with the lemme. This might indicate a mistake. We will skip this word."
    elsif Word.where({"word"=>lemme, "gender" => gender}).count > 1
      ap "Too many words in the DB with the lemme. This might indicate a mistake. We will skip this word."
    else
      word = Word.where({"word"=>lemme, "gender" => gender}).first
      if word[:frequency] == -1
        word.update_attributes({:word_plural => word[0], :frequency => total_freq})
      else
        word.update_attributes({:word_plural => word[0]})
      end
    end
  end
end