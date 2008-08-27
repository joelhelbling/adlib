class AdlibSnippetsController < ActionController::Base

  append_view_path File.expand_path(File.dirname(__FILE__) + '/../views') 
  append_before_filter :logged_in?

  def new
    @adlib_snippet = AdlibSnippet.new :page_id => params[:adlib_page_id], 
                                      :slot => params[:slot]
    render :template => 'edit'
  end
  
  def create
    @adlib_snippet = AdlibSnippet.new :page_id => params[:adlib_page_id], 
                                      :slot => params[:slot], 
                                      :content => params[:content]
    if @adlib_snippet.save
      @page = AdlibPage.find(params[:adlib_page_id].to_i)
      redirect_to @page.full_slug
    else
      render :template => 'edit'
    end
  end
  
  def edit
    @adlib_snippet = AdlibSnippet.find(params[:id].to_i)
  end

  def update
    @adlib_snippet = AdlibSnippet.find(params[:id].to_i)
    @adlib_snippet.content = params[:content]
    if @adlib_snippet.save
      @page = AdlibPage.find(params[:adlib_page_id].to_i)
      redirect_to @page.full_slug
    else
      render :template => 'edit'
    end
  end

  protected
  
  def logged_in?
    if session[:adlib_user_id]
      true
    else
      redirect_to new_adlib_session_path
    end
  end
  
end
