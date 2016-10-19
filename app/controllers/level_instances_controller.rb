class LevelInstancesController < ApplicationController

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
    redirect_to level_instance_run_index_path(:level_instance_id => @level_instance.id)
  end
end