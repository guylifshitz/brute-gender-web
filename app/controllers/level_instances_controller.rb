
class LevelInstancesController < ApplicationController
  respond_to :html, :js

  # GET /level_instances
  def index
  end


  # POST /level_instances/create
  def create
    level = Level.find(params[:level_id])

    @level_instance = LevelInstance.new({:level => level, :user => current_user, :complete_count => 0, :correct_completion_percent => 0})

    level.words.each do |word|
      ap @level_instance.level.category
      cat = @level_instance.level.category
      ap "cat"
      ap cat
      WordScore.create({:level_instance => @level_instance, :word => word, :category => cat, :user => current_user})
    end

    success = @level_instance.save

    redirect_to action: "show", id: @level_instance

    # redirect_to level_instance_run_index_path(:level_instance_id => @level_instance.id)
  end

  def show
    @level_instance = LevelInstance.find(params[:id])
    @speak = UserConfiguration.where({:user => current_user}).first[:speak]
    set_definition @level_instance
  end

  def finished
    @level_instance = LevelInstance.find(params[:level_instance_id])
  end

  def select_masculine
    check_word params[:level_instance_id], "m"
  end

  def select_feminine
    check_word params[:level_instance_id], "f"
  end
  
private 

  def set_definition level_instance
    @word_score = level_instance.word_scores[level_instance[:complete_count]]

    w = @word_score.word
    @word = w[:word]

    @definition_fr = w[:definition_fr]
    if @definition_fr == nil
      @definition_fr = "-"
    end

    @definition_en = w[:definition_en]
    if @definition_en == nil
      @definition_en = "-"
    else
      @definition_en = "("+@definition_en.uniq.join(", ")+")"
    end
  end

  def check_word level_instance_id, gender
    ap level_instance_id
    @level_instance = LevelInstance.find(level_instance_id)

    word_score = @level_instance.word_scores[@level_instance[:complete_count]]
    @correct = false
    @wait_time = 1500
    if word_score.word[:gender] == gender
      @correct = true
      @wait_time = 300
    end
    word_score.update_attribute(:correct,  @correct)

    @level_instance.update_attribute(:complete_count,  @level_instance[:complete_count] + 1)
    
    if @level_instance[:complete_count] >= @level_instance.word_scores.count
       #  DO SOMETHING
    else
      set_definition @level_instance
    end

    @speak = UserConfiguration.where({:user => current_user}).first[:speak]

    respond_to do |format|
      format.js
    end
end

end
