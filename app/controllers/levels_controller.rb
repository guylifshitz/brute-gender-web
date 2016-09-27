class LevelsController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!

  steps :start, :word, :finished

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

  def get_level_completion level_id
    LevelInstance.where({:level_id => level_id})
  end

end