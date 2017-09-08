class ApiController < ApplicationController
  
  def definitions
  	ap params
    
    word_text = definitions_params[:word].downcase
    ps = Word.find_words(word_text)

    render :json => ps
  end

private
  def definitions_params
    params.permit(:word)
  end
end
