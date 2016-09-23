class LevelInstancesController < ApplicationController

  # GET /level_runs
  def index
    ap "your level runs"
  end

  # POST /level_runs/create
  def create
    ap params
    @level_instance = LevelInstance.new({:level => Level.find(params[:level_id]), :user => current_user, :count => 0})
    # TODO: case when create fails, may not be needed if we can manage to only use the DS version (not create a local)

    ap "@level_instance.level.words"
    ap @level_instance.level.words
    @level_instance.words_ordered = @level_instance.level.words
    ap @level_instance

    success = @level_instance.save
    redirect_to level_instance_run_index_path(:level_instance_id => @level_instance.id)
  end

end