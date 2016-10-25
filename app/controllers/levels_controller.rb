class LevelsController < ApplicationController
  before_action :authenticate_user!

  def index
    @levels = Level.all

    @level_completion = {}

    @levels.each do |level|
      highest_level_completion = 0
      LevelInstance.where(:level_id => level.id).each do |level_instance|
        if level_instance[:correct_completion_percent] > highest_level_completion
          highest_level_completion = level_instance[:correct_completion_percent]
        end
      end
      @level_completion[level.id] = highest_level_completion
    end
  end


  def show
    @level = Level.find(params[:id])


    @name = @level[:name]
    @description = @level[:description]

    @word_correct_counts = {}

    @level.words.each do |word|
      @word_correct_counts[word] = "-"
    end
    #   correct_count = 0

    #   word_scores_for_word = current_user.word_scores.where(word: level_word_score.word)

    #   word_scores_for_word.each do |word_word_score|
    #     if word_word_score[:correct]
    #       correct_count += 1
    #     end
        
    #     if word_word_score[:correct] != nil
    #       @word_correct_counts[level_word_score.word] = correct_count / word_scores_for_word.count.to_f
    #     else
    #       @word_correct_counts[level_word_score.word] = "-"
    #     end
    #   end
    # end
  end

  def get_level_completion level_id
    LevelInstance.where({:level_id => level_id})
  end

end