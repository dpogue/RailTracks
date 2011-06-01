class LibrariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :is_admin?

  respond_to :html, :only => :index
  respond_to :json, :only => [:index, :show]
  respond_to :js, :except => [:index, :show]

  def index
    @libraries = Library.all
    respond_with @libraries
  end

  def new
    @lib = Library.new
    respond_with @lib
  end

  def create
    @lib = Library.new(params[:library])
    if @lib.save
      render
    else
      render :json => {:error => true}
    end
  end

  def show
    @lib = Library.find_by_id(params[:id])
    respond_with @lib
  end

  def destroy
    @id = params[:id]
    lib = Library.find_by_id(@id)
    lib.destroy
    render
  end

  private
  def is_admin?
    return render :nothing => true, :status => 401 unless current_user.try(:admin?)
  end
end
