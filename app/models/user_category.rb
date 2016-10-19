class UserCategory < Category
  has_many :words, as: :selected_words
  has_many :words, as: :removed_words
end
