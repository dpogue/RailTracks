class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def pjax?
    return true if request.headers['X-PJAX']
  end
end
