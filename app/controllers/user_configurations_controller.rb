class UserConfigurationsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js

  def enable_microphone
    ap "enable_microphone"
  end

  def disable_microphone
    ap "disable_microphone"
  end

  def enable_speak
    ap "enable_speak"
    ap params

    uc = UserConfiguration.where({:user => params[:user_id]}).first
    ap uc.update_attribute(:speak, true)

    respond_to do |format|
      format.js
    end
  end

  def disable_speak
    ap "disable_speak"

    uc = UserConfiguration.where({:user => params[:user_id]}).first
    ap uc.update_attribute(:speak, false)

    respond_to do |format|
      format.js
    end
  end

  def enable_sound
    ap "enable_sound"
  end

  def disable_sound
    ap "disable_sound"
  end

end
