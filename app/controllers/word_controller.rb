class WordController < ApplicationController

  before_action :authenticate_user!

  def show
    # word_id = rand(Word.count)
    # word = Word.order("RANDOM()").limit(1).first
    word = Word.find(params[:id]);
    @word_text = word["word"]

    @definition_fr = word[:definition_fr]
    if @definition_fr == nil
      @definition_fr = "-"
    end

    @definition_en = word[:definition_en]
    if @definition_en == nil
      @definition_en = "-"
    else
      @definition_en = "("+@definition_en.uniq.join(", ")+")"
    end
  end
end
