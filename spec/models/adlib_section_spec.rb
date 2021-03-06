require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module AdlibSectionSpecHelper
  def valid_section
    AdlibSection.new :name => 'main_menu'
  end
  
  def setup_three_pages
    @page1 = flexmock(:model, AdlibPage)
    @page2 = flexmock(:model, AdlibPage)
    @page3 = flexmock(:model, AdlibPage)
    @section.pages = [@page1, @page2, @page3]
  end
end

describe AdlibSection do
  include AdlibSectionSpecHelper

  before(:each) do
    @section = valid_section
  end

  it "should be valid" do
    @section.should be_valid
  end

  it "should have many pages" do
    association = AdlibSection.reflect_on_association(:pages)
    association.macro.should == :has_many
    association.class_name.should == 'AdlibPage'
    association.options[:foreign_key].should == 'section_id'
    association.options[:order].should == 'lft'
  end
  
  it "should be invalid without a name" do
    @section.name = ''
    @section.should_not be_valid
    @section.should have(1).error_on(:name)
  end

  it "should be invalid if name uses non-word characters" do
    ['0Dollar$', '*', 'no-dashes', 'no.dots', 'no spaces'].each do |invalid_name|
      @section.name = invalid_name
      @section.should_not be_valid
      @section.should have(1).error_on(:name)
    end
  end

  it "should be invalid if name is more than 50 characters" do
    @section.name = 'x'*51
    @section.should_not be_valid
    @section.should have(1).error_on(:name)
  end

  it "should be invalid if name is not unique" do
    @section.save!
    @section = valid_section
    @section.should_not be_valid
    @section.should have(1).error_on(:name)
  end

  it "should have an array of links" do
    setup_three_pages
    @page1.should_receive(:link_to_self).and_return("<a href='/one/'>One</a>")
    @page2.should_receive(:link_to_self).and_return("<a href='http://www.google.com/' target='_blank'>Two</a>")
    @page3.should_receive(:link_to_self).and_return("<a href='/one/'>Three</a>")
    
    @section.links.should == [ "<a href='/one/'>One</a>", 
                               "<a href='http://www.google.com/' target='_blank'>Two</a>", 
                               "<a href='/one/'>Three</a>" ]
  end

end
