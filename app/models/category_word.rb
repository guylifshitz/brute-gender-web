class CategoryWord < ActiveRecord::Base
  belongs_to :word
  belongs_to :category
end
