# UserWords.create({:user_id => current_user, :word_text => "test"})

class UserWordsController < ApplicationController

  before_action :authenticate_user!


  def index
    all_words = UserWord.where(:user_id => current_user)

    @words = []
    # @output_words = []

    all_words.each do |word|
      a_word = {}
      a_word[:word] = word
      a_word[:examples] = word[:examples].map {|x| bold_word_in_text(word[:word_text], x)}
      @words.push(a_word)
    end
    ap @words
    
  end

  def show
    # @play_word_sound = false
    @user_word = UserWord.where({:id => params[:id]})[0]
    ap @user_word
    redirect_to Word.find(@user_word[:word_id])
  end
# 

  def edit
    @user_word = UserWord.where({:id => params[:id]})[0]
  end

  def remove
    @user_word = UserWord.where({:id => params[:id]})[0]
    @user_word.destroy
    redirect_to :action => :index
  end

private

  def bold_word_in_text(word, text)
    ap word
    return text.gsub(word, "<b>#{word}</b>")
  end

end
