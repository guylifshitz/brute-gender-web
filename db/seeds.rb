# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



user = User.create! :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'


file = File.open("public/words.csv");
file_contents = file.read;
word_lines = file_contents.split("\n");

Word.destroy_all

word_lines.each do |word_line|
  word_line_parts = word_line.split("\t")
  Word.create({"word"=>word_line_parts[0], "definition_en" => word_line_parts[1], "gender" => word_line_parts[2]})
end





Level.destroy_all

word_ids = []
Word.all.each do |w|
  word_ids.append(w.id)
end

Level.create({:name=>"Easy Level", :words => word_ids, :description => "Basic words youll see often"})
