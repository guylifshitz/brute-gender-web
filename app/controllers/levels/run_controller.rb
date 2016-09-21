class Levels::RunController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!

  steps :start, :word, :finish

  def show
    @level = Level.find(params[:level_id])
    ap @level

    case step
    when :start
      ap "show start"
      @name = @level[:name]
      @description = @level[:description]
    when :word
      ap "show word"
      @word_id = @level.words.sample
      @word_text = Word.find(@word_id)[:word]
      @definition = Word.find(@word_id)[:definition_en]
    when :finish
      ap "show finish"
    end

    render_wizard 
  end

  def update 
    @level = Level.find(params[:level_id])
    ap @word_text
    ap @word
    ap params

    id = 1
    render_wizard @level
  end


  def create
  end

end