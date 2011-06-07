class SongsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :except => :show
  respond_to :json, :except => :search
  respond_to :mp3, :only => :show
  respond_to :oga, :only => :show

  def index
    params[:page] = '0' unless params[:page]
    @songs = Song.find(:all,
                       :order => 'upper(title)',
                       :offset => (50*params[:page].to_i),
                       :limit => 50)
    if @songs.empty?
      render :nothing => true, :status => 204
    else
      respond_with @songs
    end
  end

  def show
    song = Song.find_by_id(params[:id])

    respond_to do |format|
      format.json do
        respond_with(song)
      end

      format.mp3 do
      end

      format.oga do
      end
    end
  end

  def search
    @songs = Song.find(:all,
                       :conditions => ['title LIKE ?', "#{params[:q].chr}%"], 
                       :order => 'upper(title)')

    respond_with(@songs)
  end
end
