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

  def update
    level_instance = LevelInstance.find(params[:id])

    level_instance.update_attribute(:complete_count,  level_instance[:complete_count] + 1)

    if level_instance.complete_count < level_instance.word_scores.count
      # jump_to(:show_word)
    end

    redirect_to action: "show", id: level_instance
  end

  def show
    ap params
    @level_instance = LevelInstance.find(params[:id])

    @speak = UserConfiguration.where({:user => current_user}).first[:speak]

    set_definition @level_instance
  end

  def select_masculine
    level_instance = LevelInstance.find(params[:level_instance_id])
    level_instance.update_attribute(:complete_count,  level_instance[:complete_count] + 1)
    render :show
  end

  def select_feminine
    ap params
    level_instance = LevelInstance.find(params[:level_instance_id])
    level_instance.update_attribute(:complete_count,  level_instance[:complete_count] + 1)

    # respond_to do |format|
    #   format.js
    # end

    render :show

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
