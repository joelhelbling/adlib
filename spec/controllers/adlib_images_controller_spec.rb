require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdlibImagesController do

  describe "(routing)" do

    it "should recognize GET /adlib/pages/13/images/42" do
      params_from(:get, '/adlib/pages/13/images/42').should ==
                 {:controller => 'adlib_images', :action => 'show', 
                  :adlib_page_id => '13', :id => '42'}
    end
    
  end

  it "should send image data on SHOW (with a valid id)" do
    sample = File.expand_path(File.dirname(__FILE__) + '/../../vendor/plugins/adlib/public/images/sample.jpg')
    image = flexmock(:model, AdlibImage)
    flexmock(AdlibImage).should_receive(:find).with(image.id).and_return(image)
    image.should_receive(:content).and_return(IO.read(sample))
    image.should_receive(:content_type).and_return('image/jpeg')
    
    get 'show', :adlib_page_id => '13', :id => image.id.to_s
    
    response.content_type.should == 'image/jpeg'
    response.headers['Content-Length'].should == 23_655
    Digest::SHA1.hexdigest(response.body).should == '778a662f26ee8074803e0eae0448b09a2eb5b95d'    
  end

  it "should send 'file_not_found.gif' on SHOW (with an invalid id)" do
    get 'show', :adlib_page_id => '13', :id => '0'
    
    response.content_type.should == 'image/gif'
    response.headers['Content-Length'].should == 1_234
    Digest::SHA1.hexdigest(response.binary_content).should == '9c3bc13f64c101515b73e31f36d52fcaf4799b0c'    
  end

  it "should send image data on SHOW (with a valid id and multiple layouts with parameters)" do
    sample = File.expand_path(File.dirname(__FILE__) + '/../../vendor/plugins/adlib/public/images/sample.jpg')
    image = flexmock(:model, AdlibImage)
    flexmock(AdlibImage).should_receive(:find).with(image.id).and_return(image)
    image.should_receive(:content).and_return(IO.read(sample))
    image.should_receive(:content_type).and_return('image/jpeg')
    
    get 'show', :adlib_page_id => '13', :id => image.id, 
                :layout => 'grayscale,crop_resized', :width => '80', :height => '100'
    
    response.content_type.should == 'image/jpeg'
    response.headers['Content-Length'].should == 2_167
    Digest::SHA1.hexdigest(response.body).should == '95b1d56d56df79c375030fc5296c0eab09f791a5'
  end

end
