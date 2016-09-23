class LevelInstances::RunController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!

  steps :start, :show_word, :check_word, :finish

  def show
    @level_instance = LevelInstance.find(params[:level_instance_id])
    ap @level

    case step
    when :start
      ap "show start"
      @name = @level_instance.level[:name]
      @description = @level_instance.level[:description]
    when :show_word
      ap "show word"
      @word_id = @level_instance.level.words[@level_instance.count]
      @word_text = Word.find(@word_id)[:word]
      @definition = Word.find(@word_id)[:definition_en]
    when :check_word
      ap "check word"
      @word_id = @level_instance.level.words[@level_instance.count]
      @word_text = Word.find(@word_id)[:word]
      @word_gender = Word.find(@word_id)[:gender]
      @definition = Word.find(@word_id)[:definition_en]
      @ws = WordScore.where(:word_id => @word_id, :user => current_user, :level_instance => @level_instance).last
      
      @correct = @ws[:correct]
      @f_clicked = false

      ap @correct
      ap @word_gender

      if @correct
        if @word_gender == "f"
          @f_clicked = true
        end
      else 
        if @word_gender == "m"
          @f_clicked = true
        end
      end

      # if params[:F]
      # else
      #   @f_clicked = false
      # end
        
    when :finish
      ap "show finish"
    end

    render_wizard 
  end

  def update
    @level_instance = LevelInstance.find(params[:level_instance_id])

    ap "update" 
    ap params

    case step
    when :start
    when :show_word
      #   @f_clicked = true
      # else
      #   @f_clicked = false
      # end

      @word_id = @level_instance.level.words[@level_instance.count]
      @word = Word.find(@word_id)

      ap "word  gender"
      ap @word[:gender]

      @correct = true

      if @word[:gender] == "f"
        if params[:F]
          @correct = true
        else
          @correct = false
        end
      else
        if params[:M]
          @correct = true
        else
          @correct = false
        end
      end


      WordScore.create({:word =>@word, :user => current_user, :level_instance => @level_instance, :correct => @correct})
    when :check_word
      @level_instance.count = @level_instance.count + 1

      if @level_instance.count < @level_instance.level.words.count
        jump_to(:show_word)
      end

    end

    # @level_instance.save!

    render_wizard @level_instance

  end


  def create
  end

end