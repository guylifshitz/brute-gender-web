file = File.open("public/words.csv");
file_contents = file.read;
word_lines = file_contents.split("\n");

Word.destroy_all

word_lines.each do |word_line|
  word_line_parts = word_line.split("\t")
  Word.create({"word"=>word_line_parts[0], "definition_en" => word_line_parts[1], "gender" => word_line_parts[2]})
end

