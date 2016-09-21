class WordController < ApplicationController

  before_action :authenticate_user!

  def show
    # word_id = rand(Word.count)
    # word = Word.order("RANDOM()").limit(1).first
    word = Word.find(params[:id]);
    @word_text = word["word"]
    @definition = word["definition_en"]
  end

end
