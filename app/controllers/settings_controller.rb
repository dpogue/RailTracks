class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @settings = RtSettings
    @curtab = 'application'
    render :action => 'application', :layout => !pjax?
  end

  def application
    @settings = RtSettings
    @curtab = 'application'
    render :layout => !pjax?
  end

  def update_application
    @settings = RtSettings
    @curtab = 'application'
    @settings.update_attributes(params[:settings])
    flash[:notice] = 'Settings saved.'
    render :action => 'application', :layout => !pjax?
  end

  def library
    @lib = Library.all
    @curtab = 'library'
    render :layout => !pjax?
  end
end
