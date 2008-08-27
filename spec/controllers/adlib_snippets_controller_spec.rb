require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdlibSnippetsController do
  
  describe "(routing)" do

    it "should recognize GET /adlib/pages/13/snippets/new" do
      params_from(:get, '/adlib/pages/13/snippets/new').should ==
                 {:controller => 'adlib_snippets', :action => 'new',
                  :adlib_page_id => '13' }
    end

    it "should recognize POST /adlib/pages/13/snippets" do
      params_from(:post, '/adlib/pages/13/snippets').should ==
                 {:controller => 'adlib_snippets', :action => 'create',
                  :adlib_page_id => '13'}
    end

    it "should recognize GET /adlib/pages/13/snippets/42/edit" do
      params_from(:get, '/adlib/pages/13/snippets/42/edit').should ==
                 {:controller => 'adlib_snippets', :action => 'edit',
                  :adlib_page_id => '13', :id => '42' }
    end

    it "should recognize POST /adlib/snippets/42" do
      params_from(:put, '/adlib/pages/13/snippets/42').should ==
                 {:controller => 'adlib_snippets', :action => 'update', 
                  :adlib_page_id => '13', :id => '42' }
    end

  end

  describe "(not logged in)" do
    
    it "should redirect to 'adlib/session/new' on NEW" do
      get 'new', :adlib_page_id => '13'
      
      response.should redirect_to(new_adlib_session_path)
    end

    it "should redirect to 'adlib/session/new' on CREATE" do
      post 'create', :adlib_page_id => '13'
      
      response.should redirect_to(new_adlib_session_path)
    end

    it "should redirect to 'adlib/session/new' on EDIT" do
      get 'edit', :adlib_page_id => '13', :id => '42'
      
      response.should redirect_to(new_adlib_session_path)
    end

    it "should redirect to 'adlib/session/new' on UPDATE" do
      post 'update', :adlib_page_id => '13', :id => '42'
      
      response.should redirect_to(new_adlib_session_path)
    end
  
  end

  describe "(logged in)" do
  
    before(:each) do
      @user = flexmock(:model, AdlibUser)
      @page = flexmock(:model, AdlibPage)      
      @snippet = flexmock(:model, AdlibSnippet)      
      session[:adlib_user_id] = @user.id
      flexmock(AdlibPage).should_receive(:find).with(@page.id).and_return(@page)
      flexmock(AdlibSnippet).should_receive(:find).with(@snippet.id).and_return(@snippet)
    end

    it "should render 'adlib_snippets/edit' on NEW" do
      get 'new', :adlib_page_id => @page.id.to_s, :slot => 'main'
      
      response.should render_template('adlib_snippets/edit')
      assigns[:adlib_snippet].should_not be_nil
      assigns[:adlib_snippet].page_id.should == @page.id
      assigns[:adlib_snippet].slot.should == 'main'
    end

    it "should render 'adlib_snippets/new' on an unsuccessful CREATE" do
      flexmock(AdlibSnippet).should_receive(:new).and_return(@snippet)
      @snippet.should_receive(:save).and_return(false)

      post 'create', :adlib_page_id => @page.id.to_s, :slot => 'main', :content => '<p>Hello World!</p>'
      
      response.should render_template('adlib_snippets/edit')
      assigns[:adlib_snippet].should == @snippet
    end

    it "should redirect to the page view on a successful CREATE" do
      flexmock(AdlibSnippet).should_receive(:new).and_return(@snippet)
      @snippet.should_receive(:save).and_return(true)
      @page.should_receive(:full_slug).and_return('/foo/bar/baz/')

      post 'create', :adlib_page_id => @page.id.to_s, :slot => 'main', :content => '<p>Hello World!</p>'
      
      response.should redirect_to('/foo/bar/baz/')
    end

    it "should create the snippet on a successful CREATE" do
      flexmock(AdlibSnippet).should_receive(:new).and_return(@snippet)
      @snippet.should_receive(:save).and_return(true).once
      @page.should_receive(:full_slug).and_return('/foo/bar/baz/')

      post 'create', :adlib_page_id => @page.id.to_s, :slot => 'main', :content => '<p>Something Else</p>'
    end

    it "should render 'adlib_snippets/edit' on EDIT" do
      get 'edit', :adlib_page_id => @page.id.to_s, :id => @snippet.id.to_s
      
      response.should render_template('adlib_snippets/edit')
      assigns[:adlib_snippet].should_not be_nil
      assigns[:adlib_snippet].id.should == @snippet.id
    end

    it "should render 'adlib_snippets/edit' on an unsuccessful UPDATE" do
      @snippet.should_receive(:content=)
      @snippet.should_receive(:save).and_return(false)

      post 'update', :adlib_page_id => @page.id.to_s, :id => @snippet.id.to_s, :content => '<p>Hello World!</p>'
      
      response.should render_template('adlib_snippets/edit')
      assigns[:adlib_snippet].should == @snippet
    end

    it "should redirect to the page view on a successful UPDATE" do
      @snippet.should_receive(:content=)
      @snippet.should_receive(:save).and_return(true)
      @page.should_receive(:full_slug).and_return('/foo/bar/baz/')

      post 'update', :adlib_page_id => @page.id.to_s, :id => @snippet.id.to_s, :content => '<p>Hello World!</p>'
      
      response.should redirect_to('/foo/bar/baz/')
    end

    it "should update the snippet content on a successful UPDATE" do
      @snippet.should_receive(:content=).with('<p>Something Else</p>').once
      @snippet.should_receive(:save).and_return(true)
      @page.should_receive(:full_slug).and_return('/foo/bar/baz/')

      post 'update', :adlib_page_id => @page.id.to_s, :id => @snippet.id.to_s, :content => '<p>Something Else</p>'
    end
  
  end

end
