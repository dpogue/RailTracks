class MediaController < ApplicationController
  before_filter :authenticate_user!

  def stream
    return if params[:id].nil?

    song = Song.find_by_id(params[:id])
    f = File.open(song.file, 'rb')

    response.headers['Content-Type'] = 'audio/mp3'
    response.headers['Content-Length'] = f.size.to_s
    response.headers['Content-Disposition'] = 'inline'

    render :text => f.read, :layout => false
  end

  def info
    return if params[:id].nil?

    song = Song.find_by_id(params[:id])
    data = {
      :id => song.id,
      :title => song.title,
      :artist => (song.artist.nil? ? 'Unknown' : song.artist.name),
      :album => (song.album.nil? ? 'Unknown' : song.album.name),
      :url => url_for("/media/stream/#{song.id}")
    }

    render :json => data, :layout => false
  end
end
