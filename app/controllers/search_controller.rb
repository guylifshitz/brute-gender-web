class SearchController < ApplicationController
  def get_definitions
    word_text = create_params[:word].downcase
    ps = find_words(word_text)
    render :json => ps
  end


  def external
    word_text = create_params[:word].downcase
    w = find_words(word_text)
    ap w
    w = w.first
    example = create_params[:example]

    update_hash = {}
    update_hash[:user_id] = create_params[:user_id]
    update_hash[:examples] = [example]
    update_hash[:example] = example
    update_hash[:source_example] = example
    update_hash[:source_url] = create_params[:url]
    update_hash[:source_word] = word_text
    update_hash[:type] = create_params[:type]

    if w
      ap w[:id]
      # update_hash[:word_id] = w[:id]
      update_hash[:word_text] = w[:word_text]
      update_hash[:definition] = w[:definitions][0]["definition"]
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