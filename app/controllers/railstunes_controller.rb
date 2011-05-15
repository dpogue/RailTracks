class RailstunesController < ApplicationController
  before_filter :authenticate_user!

  def index
    render :layout => !pjax?
  end

  def list
    @files = Dir.glob('/media/Music/*.mp3')
    render :layout => !pjax?
  end
end
