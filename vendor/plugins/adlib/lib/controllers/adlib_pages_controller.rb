class AdlibPagesController < ActionController::Base
   
  append_view_path File.expand_path(File.dirname(__FILE__) + '/../views') 

  def show
    @page = AdlibPage.find_by_path(params[:path]) if params[:path]
    @page = AdlibPage.find(params[:id].to_i)      if params[:id]
    render :text => '', :layout => @page.layout
  rescue ActiveRecord::RecordNotFound
    render :text => 'Page not found', :status => 404
  end


=begin
  def new
    redirect_to_default if session[:adlib_user_id]

    @adlib_user = AdlibUser.new
  end

  def create
    session[:adlib_user_id] = nil
    
    @adlib_user = AdlibUser.new
    @adlib_user.username = params[:adlib_user][:username]
    @adlib_user = AdlibUser.find_by_username(@adlib_user.username) || @adlib_user

    if @adlib_user.authenticated?(params[:adlib_user][:password])
      session[:adlib_user_id] = @adlib_user.id
      redirect_to_default
    else
      render :action => 'new'
    end
  end

  def destroy
    session[:adlib_user_id] = nil

    redirect_to_default
  end

  protected
  
  def redirect_to_default
    redirect_to '/'
  end
=end
end
