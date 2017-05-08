class SearchController < ApplicationController

  def external
    word_text = create_params[:word].downcase
    w = find_word(word_text)
    ap w
    example = create_params[:example]

    update_hash = {}
    update_hash[:user_id] = create_params[:user_id]
    update_hash[:examples] = [example]
    update_hash[:example] = example
    update_hash[:source_example] = example
    update_hash[:source_url] = create_params[:url]
    update_hash[:source_word] = word_text

    if w
      update_hash[:word_id] = w[:id]
      update_hash[:word_text] = w["word"]
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
    render :json => uw
  end

  def results
    word = params[:search][:word]
    w = find_word(word)
    redirect_to word_path(w[:id])
  end

  def search
    ap params
  end

private 
  def find_word word
    query = 'word = :w OR "Afpfp" = :w OR "Afpfs" = :w OR "Afpmp" = :w OR "Afpms" = :w OR
    "Nc?p" = :w OR "Nc?s" = :w OR "Ncfp" = :w OR "Ncfs" = :w OR "Ncmp" = :w OR "Ncms" = :w OR
    "Npfp" = :w OR "Npfs" = :w OR "Npms" = :w OR "Npmp" = :w OR
    "Vmn----" = :w OR "Vmpp---" = :w OR
    "Vmps-pf" = :w OR "Vmps-pm" = :w OR "Vmps-sf" = :w OR "Vmps-sm" = :w  OR
    "Vmcp1p-" = :w OR "Vmcp1s-" = :w OR "Vmcp2p-" = :w OR "Vmcp2s-" = :w OR "Vmcp3p-" = :w OR "Vmcp3s-" = :w OR
    "Vmif1p-" = :w OR "Vmif1s-" = :w OR
    "Vmif2p-" = :w OR "Vmif2s-" = :w OR "Vmif3p-" = :w OR "Vmif3s-" = :w OR
    "Vmii1p-" = :w OR "Vmii1s-" = :w OR "Vmii2p-" = :w OR "Vmii2s-" = :w OR "Vmii3p-" = :w OR "Vmii3s-" = :w OR
    "Vmip1p-" = :w OR "Vmip1s-" = :w OR "Vmip2p-" = :w OR "Vmip2s-" = :w OR "Vmip3p-" = :w OR "Vmip3s-" = :w OR
    "Vmis1p-" = :w OR "Vmis1s-" = :w OR "Vmis2p-" = :w OR "Vmis2s-" = :w OR "Vmis3p-" = :w OR "Vmis3s-" = :w OR
    "Vmmp1p-" = :w OR "Vmmp2p-" = :w OR "Vmmp2s-" = :w OR
    "Vmsi1p-" = :w OR "Vmsi1s-" = :w OR "Vmsi2p-" = :w OR "Vmsi2s-" = :w OR "Vmsi3p-" = :w OR "Vmsi3s-" = :w OR
    "Vmsp1p-" = :w OR "Vmsp1s-" = :w OR "Vmsp2p-" = :w OR "Vmsp2s-" = :w OR "Vmsp3p-" = :w OR "Vmsp3s-" = :w'

    w = Word.where(query, :w => word).first
    w
  end

  def create_params
    # params.permit(:word, :user_id, :example, :url)
    params.permit(:word, :user_id, :example, :url)
  end

end