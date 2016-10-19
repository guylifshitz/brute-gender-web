class CategoryWordsController < ApplicationController
  def update
    ap "update"
    ap params
    cat = CategoryWord.find(params[:id])
    cat.update_attributes(category_word_params)
    redirect_to :back

  end

  def disable
    ap params
    cw = CategoryWord.find(params[:category_word_id])
    cw.update_attribute(:include_word, false)
    redirect_to edit_category_path({:id=>cw.category})
  end

  def enable
    ap params
    cw = CategoryWord.find(params[:category_word_id])
    cw.update_attribute(:include_word, true)
    redirect_to edit_category_path({:id=>cw.category})
  end

  private

  def category_word_params
    params.require(:category_word).permit(:include_word)
  end

end