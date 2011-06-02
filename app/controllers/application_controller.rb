class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :setlayout

  protected
  def pjax?
    return true if request.headers['X-PJAX']
  end

  def setlayout
    return 'unauth' if devise_controller?
    return false if pjax?
    return 'application'
  end

end
