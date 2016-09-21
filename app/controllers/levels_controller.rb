class LevelsController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!

  steps :start, :word, :finished

  def index
    @levels = Level.all
  end 

end