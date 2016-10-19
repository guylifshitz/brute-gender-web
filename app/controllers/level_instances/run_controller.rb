class LevelInstances::RunController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!

  steps :show_word, :check_word, :finish

  def show
    @level_instance = LevelInstance.find(params[:level_instance_id])

    @play_word_sound = current_user[:sound]

    case step
    when :start
      if @level_instance.level

        @name = @level_instance.level[:name]
        @description = @level_instance.level[:description]

        @word_correct_counts = {}

        @level_instance.word_scores.each do |level_word_score|
          correct_count = 0

          word_scores_for_word = current_user.word_scores.where(word: level_word_score.word)

          word_scores_for_word.each do |word_word_score|
            if word_word_score[:correct]
              correct_count += 1
            end
            
            if word_word_score[:correct] != nil
              @word_correct_counts[level_word_score.word] = correct_count / word_scores_for_word.count.to_f
            else
              @word_correct_counts[level_word_score.word] = "-"
            end
          end
        end
      end

    when :show_word
      set_definition @level_instance

    when :check_word
      set_definition @level_instance

      @correct = @word_score[:correct]
      @f_clicked = false
      @word_gender = @word_score.word[:gender]

      if @correct
        if @word_gender == "f"
          @f_clicked = true
        end
      else 
        if @word_gender == "m"
          @f_clicked = true
        end
      end

    when :finish
    end

    render_wizard 
  end

  def update
    @level_instance = LevelInstance.find(params[:level_instance_id])

    case step
    when :start
    when :show_word

      word_score = @level_instance.word_scores[@level_instance[:complete_count]]
      word = word_score.word

      # Check which button was pressed and if it was correct
      correct = true

      if word[:gender] == "f"
        if params[:F]
          correct = true
        else
          correct = false
        end
      else
        if params[:M]
          correct = true
        else
          correct = false
        end
      end

      #  Save the level correct completion score
      if correct
        @level_instance.correct_completion_percent = @level_instance.correct_completion_percent + 1.0/@level_instance.word_scores.count * 100
        @level_instance.save!
      end

      # Make a new word's score
      word_score.update_attribute(:correct,  correct)
      ap "showowrdupdate"
      ap word_score

    when :check_word
      @level_instance.complete_count = @level_instance.complete_count + 1

      if @level_instance.complete_count < @level_instance.word_scores.count
        jump_to(:show_word)
      end

    end

    # @level_instance.save!

    render_wizard @level_instance

  end

  def create
  end

private 

  def set_definition level_instance
    ap level_instance.word_scores
    @word_score = level_instance.word_scores[level_instance[:complete_count]]

    word = @word_score.word

    @definition_fr = word[:definition_fr]
    if @definition_fr == nil
      @definition_fr = "-"
    end

    @definition_en = word[:definition_en]
    if @definition_en == nil
      @definition_en = "-"
    else
      @definition_en = "("+@definition_en.uniq.join(", ")+")"
    end
  end
end