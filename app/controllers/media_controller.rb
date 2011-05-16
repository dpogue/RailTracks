class MediaController < ApplicationController
  def stream
    return if params[:song].nil?

    song = Song.find_by_id(params[:song])
    f = File.open(song.file, 'rb')

    response.headers['Content-Type'] = 'audio/mp3'
    response.headers['Content-Length'] = f.size.to_s
    response.headers['Content-Disposition'] = 'inline'

    render :text => f.read, :layout => false
  end
end
