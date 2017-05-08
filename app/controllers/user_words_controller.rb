# UserWords.create({:user_id => current_user, :word_text => "test"})

class UserWordsController < ApplicationController

  before_action :authenticate_user!


  def index
    all_words = UserWord.where(:user_id => current_user).order(created_at: :desc)

    @words = []
    # @output_words = []

    all_words.each do |user_word|
      a_word = {}
      a_word[:user_word] = user_word
      # a_word[:examples] = user_word[:examples].map {|x| bold_word_in_text(user_word[:word_text], x)}
      a_word[:example] = bold_word_in_text(user_word[:word_text], user_word[:example])

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

  def update
    ap params

    user_word = UserWord.find(params[:id])
    user_word.update!(user_word_params)
    redirect_to user_words_path
  end

  def edit
    @user_word = UserWord.where({:id => params[:id]})[0]
    word = Word.find(@user_word[:word_id])
    @definitions = word[:definitions]
    ap @definitions
    # @definitions = []
    # @examples = []

  end

  def remove
    @user_word = UserWord.where({:id => params[:id]})[0]
    @user_word.destroy
    redirect_to :action => :index
  end

private

  def bold_word_in_text(word, text)
    if text
      return text.gsub(word, "<b>#{word}</b>")
    end
    return ""
  end

  def user_word_params
    ap "params"
    ap params
    params.require(:user_word).permit(:definition, :example)
  end

end
