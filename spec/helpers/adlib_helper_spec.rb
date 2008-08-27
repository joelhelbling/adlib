require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module AdlibHelperSpecHelper

  def placeholder_text
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, " + 
    "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  end
  
  def setup_page_snippet
    @snippet = flexmock(:model, AdlibSnippet)
    flexmock(AdlibSnippet).should_receive(:find_by_page_id_and_slot).with(@page.id, :main).and_return(@snippet)
    @snippet.should_receive(:content).and_return('<p>Hello World!</p>')
  end
  
  def setup_ancestor_snippet
    @ancestor = flexmock(:model, AdlibPage)
    @parent = flexmock(:model, AdlibPage)
    @page.should_receive(:parent).and_return(@parent)
    @parent.should_receive(:parent).and_return(@ancestor)
    @snippet = flexmock(:model, AdlibSnippet)
    flexmock(AdlibSnippet).should_receive(:find_by_page_id_and_slot).and_return(nil).by_default
    flexmock(AdlibSnippet).should_receive(:find_by_page_id_and_slot).with(@ancestor.id, :absent).and_return(@snippet)
    @snippet.should_receive(:content).and_return('<h1>Inherited Content</h1>')
  end
  
  def setup_page_image
    @image = flexmock(:model, AdlibImage)
    flexmock(AdlibImage).should_receive(:find).with(:first, :select => 'id', 
                                                    :conditions => { :page_id => @page.id, :slot => :main}
                                                    ).and_return(@image)
  end

  def setup_ancestor_image
    @ancestor = flexmock(:model, AdlibPage)
    @parent = flexmock(:model, AdlibPage)
    @page.should_receive(:parent).and_return(@parent)
    @parent.should_receive(:parent).and_return(@ancestor)
    @image = flexmock(:model, AdlibImage)
    flexmock(AdlibImage).should_receive(:find).and_return(nil).by_default
    flexmock(AdlibImage).should_receive(:find).with(:first, :select => 'id', 
                                                    :conditions => { :page_id => @ancestor.id, :slot => :absent}
                                                    ).and_return(@image)
  end
  
end

describe AdlibHelper, "adlib_user" do

  it "should return nil if not logged in" do
    adlib_user.should be_nil
  end
  
  it "should return the current logged in adlib user" do
    user = flexmock(:model, AdlibUser)
    flexmock(AdlibUser).should_receive(:find_by_id).with(user.id).and_return(user)
    session[:adlib_user_id] = user.id
          
    adlib_user.should == user
  end

end
  
describe AdlibHelper, "adlib_snippet" do
  include AdlibHelperSpecHelper

  before(:each) do
    @page = flexmock(:model, AdlibPage)
  end

  it "should render the content of the snippet" do
    setup_page_snippet
    
    adlib_snippet(:main).should == '<p>Hello World!</p>'
  end

  it "should render the content of the snippet as plain text" do
    setup_page_snippet
    
    adlib_snippet(:main, :richtext => false).should == '&lt;p&gt;Hello World!&lt;/p&gt;'
  end

  it "should render the content of an ancestor snippet" do
    setup_ancestor_snippet

    adlib_snippet(:absent, :inherit => true).should == '<h1>Inherited Content</h1>'
  end

  it "should render placeholder content" do
    adlib_snippet(:absent).should == placeholder_text
  end

  describe "(logged in)" do
    
    before(:each) do
      user = flexmock(:model, AdlibUser)
      flexmock(self).should_receive(:adlib_user).and_return(user)
    end

    it "should render the content of the snippet with an edit wrapper" do
      setup_page_snippet
      
      content_re = /<p>Hello World!<\/p>/
      href_re = /\s*?href="\/adlib\/pages\/#{@page.id}\/snippets\/#{@snippet.id}\/edit\?encoding=richtext"\s*?/
      class_re = /\s*?class="adlib-richtext"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{content_re}<\/a>/
      
      adlib_snippet(:main).should match(edit_re)
    end

    it "should render the content of the snippet as plain text with an edit wrapper" do
      setup_page_snippet

      content_re = /&lt;p&gt;Hello World!&lt;\/p&gt;/
      href_re = /\s*?href="\/adlib\/pages\/#{@page.id}\/snippets\/#{@snippet.id}\/edit\?encoding=plaintext"\s*?/
      class_re = /\s*?class="adlib-plaintext"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{content_re}<\/a>/
      
      adlib_snippet(:main, :richtext => false).should match(edit_re)
    end

    it "should render the content of an ancestor snippet with an edit wrapper" do
      setup_ancestor_snippet

      content_re = /<h1>Inherited Content<\/h1>/
      href_re = /\s*?href="\/adlib\/pages\/#{@ancestor.id}\/snippets\/#{@snippet.id}\/edit\?encoding=richtext"\s*?/
      class_re = /\s*?class="adlib-richtext"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{content_re}<\/a>/
      
      adlib_snippet(:absent, :inherit => true).should match(edit_re)
    end

    it "should render placeholder content with an edit wrapper" do
      slot_re  = /&?slot=absent/
      encoding_re = /&?encoding=richtext/
      params_re = /(#{slot_re}|#{encoding_re}){2}/
      href_re = /\s*?href="\/adlib\/pages\/#{@page.id}\/snippets\/new\?#{params_re}"\s*?/
      class_re = /\s*?class="adlib-richtext"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{placeholder_text}<\/a>/
      
      adlib_snippet(:absent).should match(edit_re)
    end

  end

end

describe AdlibHelper, "adlib_image" do
  include AdlibHelperSpecHelper

  before(:each) do
    @page = flexmock(:model, AdlibPage)
  end

  it "should render an img tag for the image content" do
    setup_page_image
    
    src_re = /\s*?src="\/adlib\/pages\/#{@page.id}\/images\/#{@image.id}"\s*?/
    alt_re = /\s*?alt="Main"\s*?/
    img_re = /<img (#{src_re}|#{alt_re}){2} \/>/
    
    adlib_image(:main).should match(img_re)
  end

  it "should render an img tag for the ancestor image content" do
    setup_ancestor_image

    src_re = /\s*?src="\/adlib\/pages\/#{@ancestor.id}\/images\/#{@image.id}"\s*?/
    alt_re = /\s*?alt="Absent"\s*?/
    img_re = /<img (#{src_re}|#{alt_re}){2} \/>/

    adlib_image(:absent, :inherit => true).should match(img_re)
  end

  it "should render an img tag with placeholder content for the image" do
    src_re = /\s*?src="\/adlib\/pages\/#{@page.id}\/images\/0"\s*?/
    alt_re = /\s*?alt="Absent"\s*?/
    img_re = /<img (#{src_re}|#{alt_re}){2} \/>/

    adlib_image(:absent).should match(img_re)
  end

  it "should render an img tag for the image content with layout" do    setup_page_image
    
    layout_re = /&?layout=grayscale%2Cresize_and_crop/
    width_re  = /&?width=80/
    height_re = /&?height=100/
    params_re = /(#{layout_re}|#{width_re}|#{height_re}){3}/
    src_re = /\s*?src="\/adlib\/pages\/#{@page.id}\/images\/#{@image.id}\?#{params_re}"\s*?/
    alt_re = /\s*?alt="Main"\s*?/
    img_re = /<img (#{src_re}|#{alt_re}){2} \/>/
    
    adlib_image(:main, :layout => [:grayscale, :resize_and_crop], :width => 80, :height => 100).should match(img_re)
  end

  describe "(logged in)" do
    
    before(:each) do
      user = flexmock(:model, AdlibUser)
      flexmock(self).should_receive(:adlib_user).and_return(user)
    end
  
    it "should render an img tag for the image content with an edit wrapper" do
      setup_page_image

      src_re = /\s*?src="\/adlib\/pages\/#{@page.id}\/images\/#{@image.id}"\s*?/
      alt_re = /\s*?alt="Main"\s*?/
      img_re = /<img (#{src_re}|#{alt_re}){2} \/>/
      href_re = /\s*?href="\/adlib\/pages\/#{@page.id}\/images\/#{@image.id}\/edit"\s*?/
      class_re = /\s*?class="adlib-image"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{img_re}<\/a>/

      adlib_image(:main).should match(edit_re)
    end

    it "should render an img tag for the ancestor image content with an edit wrapper" do
      setup_ancestor_image

      src_re = /\s*?src="\/adlib\/pages\/#{@ancestor.id}\/images\/#{@image.id}"\s*?/
      alt_re = /\s*?alt="Absent"\s*?/
      img_re = /<img (#{src_re}|#{alt_re}){2} \/>/
      href_re = /\s*?href="\/adlib\/pages\/#{@ancestor.id}\/images\/#{@image.id}\/edit"\s*?/
      class_re = /\s*?class="adlib-image"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{img_re}<\/a>/

      adlib_image(:absent, :inherit => true).should match(edit_re)
    end

    it "should render an img tag with placeholder content for the image with an edit wrapper" do
      src_re = /\s*?src="\/adlib\/pages\/#{@page.id}\/images\/0"\s*?/
      alt_re = /\s*?alt="Absent"\s*?/
      img_re = /<img (#{src_re}|#{alt_re}){2} \/>/
      href_re = /\s*?href="\/adlib\/pages\/#{@page.id}\/images\/new\?slot=absent"\s*?/
      class_re = /\s*?class="adlib-image"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{img_re}<\/a>/

      adlib_image(:absent).should match(edit_re)
    end

    it "should render an img tag for the image content with formatting instructions with an edit wrapper" do      setup_page_image
      
      layout_re = /&?layout=grayscale%2Cresize_and_crop/
      width_re  = /&?width=80/
      height_re = /&?height=100/
      params_re = /(#{layout_re}|#{width_re}|#{height_re}){3}/
      src_re = /\s*?src="\/adlib\/pages\/#{@page.id}\/images\/#{@image.id}\?#{params_re}"\s*?/
      alt_re = /\s*?alt="Main"\s*?/
      img_re = /<img (#{src_re}|#{alt_re}){2} \/>/
      href_re = /\s*?href="\/adlib\/pages\/#{@page.id}\/images\/#{@image.id}\/edit\?#{params_re}"\s*?/
      class_re = /\s*?class="adlib-image"\s*?/
      span_re = /<span class="adlib-edit">EDIT<\/span>/
      edit_re = /<a (#{href_re}|#{class_re}){2}>#{span_re}#{img_re}<\/a>/
      
      adlib_image(:main, :layout => [:grayscale, :resize_and_crop], :width => 80, :height => 100).should match(edit_re)
    end

  end

end
