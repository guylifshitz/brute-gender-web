class NotesController < ApplicationController

  def external
    note_text = create_params[:note]
    note_title = create_params[:title]
    example = create_params[:example]

    update_hash = {}
    update_hash[:user_id] = create_params[:user_id]
    update_hash[:type] = create_params[:type]

    ap update_hash
    uw = Note.create(update_hash)
    
    render :json => uw
  end

private 
  def create_params
    params.permit(:user_id, :note, :title, :type, :url)
  end

end