class LevelInstancesController < ApplicationController

  # GET /level_instances
  def index
  end

  # POST /level_instances/create_wrong_words_level
  def create_wrong_words_level
     # get user's wrong words
      wrong_words = WordScore.where({:user_id=>current_user})
      wrong_word_ids = []
      wrong_words.each do |wrong_word|
        if wrong_word.correct == false
          wrong_word_ids.push(wrong_word.word_id)
        end
      end
      ap wrong_word_ids
      @level_instance = LevelInstance.new({:user => current_user, :complete_count => 0, :correct_completion_percent => 0})
      success = @level_instance.save
      redirect_to level_instance_run_index_path(:level_instance_id => @level_instance.id)
  end

  # POST /level_instances/create
  def create
    level = Level.find(params[:level_id])

    @level_instance = LevelInstance.new({:level => level, :user => current_user, :complete_count => 0, :correct_completion_percent => 0})

    level.words.each do |word|
      WordScore.create({:level_instance => @level_instance, :word => word})
    end

    success = @level_instance.save
    redirect_to level_instance_run_index_path(:level_instance_id => @level_instance.id)
  end
end