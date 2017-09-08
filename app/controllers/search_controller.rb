class SearchController < ApplicationController
  def get_definitions
    word_text = create_params[:word].downcase
    ps = find_words(word_text)
    render :json => ps
  end



  def results
    word = params[:search][:word]
    words = find_words(word)
    ap words
    redirect_to search_get_definitions_path(params)
    # redirect_to word_path(words.first[:id])
  end

  def search
    ap params
  end

private 

  def create_params
    # params.permit(:word, :user_id, :example, :url)
    params.permit(:word, :user_id, :example, :url, :type)
  end

end