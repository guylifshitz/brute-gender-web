class WordsController < ApplicationController

  before_action :authenticate_user!

  def show
    # word_id = rand(Word.count)
    # word = Word.order("RANDOM()").limit(1).first
    @word = Word.find(params[:id]);
    @word_text = @word["word"]

    @gender = @word[:gender]
    @definitions = @word[:definitions]
    @translations = @word[:translations]
  end

  def update
    ap "update"
    render 'show'
  end

  def add
    @word = Word.find(params[:id])
    ap @word
    ap current_user
    UserWord.create({:word_id => @word[:id], :word_text=>@word["word"], :user_id=>current_user[:id]})
    redirect_to action: "show"
  end

end
