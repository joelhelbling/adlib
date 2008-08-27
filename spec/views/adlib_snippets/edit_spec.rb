require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '/adlib/pages/13/snippets/new' do

  before(:each) do
    @controller.view_paths = File.expand_path(File.dirname(__FILE__) + '/../../../vendor/plugins/adlib/lib/views')
    @snippet = flexmock(:model, AdlibSnippet)
    @snippet.should_receive(:content).and_return(nil).by_default
    assigns[:adlib_snippet] = @snippet
  end
  
  it "should display a snippet form with a content text area" do
    render '/adlib_snippets/edit'
    
    response.should have_tag('textarea[name=?]', 'adlib_snippet[content]')
    response.should have_tag('input[value=?]', 'Save')
  end

end
