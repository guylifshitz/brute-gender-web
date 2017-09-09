class ApiController < ApplicationController
  
  def definitions
  	ap params
    
    word_text = definitions_params[:word].downcase
    ps = Word.find_words(word_text)

    render :json => ps
  end

  def add_user_word
    word_text = add_user_word_params[:word].downcase
    w = Word.find_words(word_text)
    ap w
    w = w.first
    example = add_user_word_params[:example]

    update_hash = {}
    update_hash[:user_id] = add_user_word_params[:user_id]
    update_hash[:examples] = [example]
    update_hash[:example] = example
    update_hash[:source_example] = example
    update_hash[:source_url] = add_user_word_params[:url]
    update_hash[:source_word] = word_text
    update_hash[:type] = add_user_word_params[:type]

    update_hash[:definition] = add_user_word_params[:definition]

    if w
      ap w[:id]
      update_hash[:word_text] = w[:text]
      if update_hash[:definition] == nil
        update_hash[:definition] = w[:definitions][0]["definition"]
      end
    else
      update_hash[:word_text] = word_text
      update_hash[:definition] = ""
    end

    # update_hash[:word_id] = w[:id]
    # update_hash[:word_id] = w[:id]
    # :word_id => w[:id], :word_text=>w["word"], :user_id=>user_id, :examples=>[example], :example => example, :definition => w[:definitions][0]["definition"], :source_url => source_url
    ap update_hash
    uw = UserWord.create(update_hash)

    # if w
    #   uw = UserWord.create(:word_id => w[:id], :word_text=>w["word"], :user_id=>user_id, :examples=>[example], :example => example, :definition => w[:definitions][0]["definition"], :source_url => source_url)
    # else
    #   uw = UserWord.create(:word_id => nil, :word_text=>word_param, :user_id=>user_id, :examples=>[example],  :example => example, :definition => "", :source_url => source_url)
    # end
    render :json => w
  end

private
  def definitions_params
    params.permit(:word)
  end

  def add_user_word_params
    params.permit(:word, :user_id, :example, :url, :type, :definition)
  end
end
