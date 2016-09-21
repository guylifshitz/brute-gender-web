Level.destroy_all

word_ids = []
Word.all.each do |w|
  word_ids.append(w.id)
end

Level.create({:name=>"Easy Level", :words => word_ids, :description => "Basic words youll see often"})
