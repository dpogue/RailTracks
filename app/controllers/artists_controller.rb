class ArtistsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html
  respond_to :json, :only => [:index]

  def index
    params[:page] = '0' unless params[:page]
    @artists = Artist.find(:all,
                           :order => 'upper(name)',
                           :offset => (50*params[:page].to_i),
                           :limit => 50)
    if @artists.empty?
      render :nothing => true, :status => 204
    else
      respond_with @artists
    end
  end

  def show
    a = Artist.find_by_id(params[:id])
    @songs = a.songs.sort_by { |s|
      k = []
      k << (s.album.nil? ? '' : s.album.name.sub(/[^a-zA-Z 0-9]+/,'').downcase)
      k << (s.track.nil? ? 0 : s.track)
      k << s.title.sub(/[^a-zA-Z 0-9]+/,'').downcase
      k
    }
    respond_with(@songs)
  end

  def search
    @artists = Artist.find(:all,
                           :conditions => ['name LIKE ?', "#{params[:q].chr}%"], 
                           :order => 'upper(name)')

    respond_with(@artists)
  end
end
