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
        f = File.open(song.file, 'rb')

        response.headers['Content-Type'] = 'audio/mp3'
        response.headers['Content-Length'] = f.size.to_s
        response.headers['X-Content-Duration'] = song.length.to_s
        response.headers['Content-Disposition'] = 'inline'

        self.response_body = proc do |response, output|
          while (d = f.read(1024))
            response.write d
          end
        end
      end

      format.oga do
        response.headers['Content-Type'] = 'audio/ogg'
        response.headers['X-Content-Duration'] = song.length.to_s
        response.headers['Content-Disposition'] = 'inline'

        self.response_body = proc do |response, output|
          IO.popen("mpg123 -w - \"#{song.file}\" | oggenc -") do |f|
            while (d = f.read(1024))
              response.write d
            end
          end
        end
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

#HAAAAAACK
class Rack::Response
  def close
    @body.close if @body.respond_to?(:close)
  end
end
