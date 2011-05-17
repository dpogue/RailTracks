class RailtracksController < ApplicationController
  before_filter :authenticate_user!

  def index
    render :layout => !pjax?
  end

  def songs
    @songs = Song.all.sort_by { |s|
      k = []
      k << (s.artist.nil? ? '' : s.artist.name.sub(/[^a-zA-Z 0-9]+/,'').downcase)
      k << (s.album.nil? ? '' : s.album.name.sub(/[^a-zA-Z 0-9]+/,'').downcase)
      k << (s.track.nil? ? 0 : s.track)
      k << s.title.sub(/[^a-zA-Z 0-9]+/,'').downcase
      k
    }
    render :layout => !pjax?
  end

  def artists
    params[:id] = '0' unless params[:id]
    numeric = true if Float(params[:id]) rescue false
    if numeric
      @artists = Artist.find(:all, :order => :name, :offset => (50*params[:id].to_i), :limit => 50)
      return render :status => 204 if @artists.empty?
    else
      @artists = Artist.find(:all, :conditions => ['name LIKE ?', "#{params[:id].chr}%"], :order => :name)
    end

    respond_to do |format|
      format.json { render :json => @artists }
      format.html { render :layout => !pjax? }
    end
  end

  def artist
    render :action => 'artists', :layout => !pjax? unless params[:id]

    a = Artist.find_by_id(params[:id])
    @songs = a.songs.sort_by { |s|
      k = []
      k << (s.album.nil? ? '' : s.album.name.sub(/[^a-zA-Z 0-9]+/,'').downcase)
      k << (s.track.nil? ? 0 : s.track)
      k << s.title.sub(/[^a-zA-Z 0-9]+/,'').downcase
      k
    }
    render :action => 'songs', :layout => !pjax?
  end
end
