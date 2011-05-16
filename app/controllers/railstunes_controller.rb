class RailstunesController < ApplicationController
  before_filter :authenticate_user!

  def index
    render :layout => !pjax?
  end

  def list
    @files = Dir.glob('/media/Music/*.mp3')
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
    @artists = Artist.all.sort_by { |a| a.name.downcase }
    render :layout => !pjax?
  end
end
