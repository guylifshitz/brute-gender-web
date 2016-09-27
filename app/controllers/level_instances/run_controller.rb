class LevelInstances::RunController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!

  steps :start, :show_word, :check_word, :finish

  def show
    @level_instance = LevelInstance.find(params[:level_instance_id])
    ap @level

    case step
    when :start
      if @level_instance.level
        @name = @level_instance.level[:name]
        @description = @level_instance.level[:description]
      end
      
    when :show_word
      @word_id = @level_instance.words_ordered[@level_instance.count]
      @word_text = Word.find(@word_id)[:word]
      @definition = Word.find(@word_id)[:definition_en]
    when :check_word
      @word_id = @level_instance.words_ordered[@level_instance.count]
      @word_text = Word.find(@word_id)[:word]
      @word_gender = Word.find(@word_id)[:gender]
      @definition = Word.find(@word_id)[:definition_en]
      @ws = WordScore.where(:word_id => @word_id, :user => current_user, :level_instance => @level_instance).last

      @correct = @ws[:correct]
      @f_clicked = false

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

      @word_id = @level_instance.words_ordered[@level_instance.count]
      @word = Word.find(@word_id)

      # Check which button was pressed and if it was correct
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

      #  Save the level correct completion score
      if @correct
        @level_instance.correct_completion_percent = @level_instance.correct_completion_percent + 1.0/@level_instance.words_ordered.count * 100
        @level_instance.save!        
      end

      # Make a new word's score
      WordScore.create({:word =>@word, :user => current_user, :level_instance => @level_instance, :correct => @correct})
    when :check_word
      @level_instance.count = @level_instance.count + 1

      if @level_instance.count < @level_instance.words_ordered.count
        jump_to(:show_word)
      end

    end

    # @level_instance.save!

    render_wizard @level_instance

  end


  def create
  end

end