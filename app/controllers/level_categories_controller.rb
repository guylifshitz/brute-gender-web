class LevelCategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = LevelCategory.all
  end

  def show
    @levels = LevelCategory.find(params[:id]).levels
    ap @levels

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
end