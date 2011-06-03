class RailtracksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_security

  def index
    render :layout => !pjax?
  end

  # SLOW AND PAINFUL
  # Do not use this function!
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
      @artists = Artist.find(:all,
                             :order => 'upper(name)',
                             :offset => (50*params[:id].to_i),
                             :limit => 50)
      if @artists.empty?
        respond_to do |format|
          format.json { render :json => @artists, :status => 204 }
          format.html { render :layout => false, :status => 204 }
        end
        return
      end
    else
      @artists = Artist.find(:all,
                             :conditions => ['name LIKE ?', "#{params[:id].chr}%"], 
                             :order => 'upper(name)')
    end

    @doajaxload = (params[:id] == '0')

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

  protected
  def check_security
    if current_user.try(:admin?)
      if current_user.username == 'admin'
        current_user.username = 'Change_Me'
        current_user.save!
        flash[:notice] = "You must change the default admin credentials for security purposes."
        redirect_to edit_user_registration_path
      end
    end
  end
end
