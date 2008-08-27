require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module AdlibImageSpecHelper
  def valid_image
    @page = flexmock(:model, AdlibPage)
    AdlibImage.new :page => @page, :slot => 'main'
  end
end

describe AdlibImage do
  include AdlibImageSpecHelper

  before(:each) do
    @image = valid_image
  end

  it "should be valid" do
    @image.should be_valid
  end

  it "should belong to a page" do
    association = AdlibImage.reflect_on_association(:page)
    association.macro.should == :belongs_to
    association.class_name.should == 'AdlibPage'
  end
 
  it "should be invalid without a page" do
    @image.page = nil
    @image.should_not be_valid
    @image.should have(1).error_on(:page)
  end

  it "should be invalid without a slot" do
    @image.slot = ''
    @image.should_not be_valid
    @image.should have(1).error_on(:slot)
  end

  it "should be invalid if slot is more than 50 characters" do
    @image.slot = 'x'*51
    @image.should_not be_valid
    @image.should have(1).error_on(:slot)
  end

  it "should be invalid if slot uses non-word characters" do
    ['0Dollar$', '*', 'no-dashes', 'no.dots', 'no spaces'].each do |invalid_slot|
      @image.slot = invalid_slot
      @image.should_not be_valid
      @image.should have(1).error_on(:slot)
    end
  end

  it "should be invalid if slot is not unique within the same page" do
    existing = valid_image
    existing.save!
    @image.page = existing.page
    @image.should_not be_valid
    @image.should have(1).error_on(:slot)
  end

  it "should be valid if slot is not-unique but on a different page" do
    existing = valid_image
    existing.save!
    @image.should be_valid
  end

  it "should be invalid with a non-numeric size" do
    @image.size = 'xyz'
    @image.should_not be_valid
    @image.should have(1).error_on(:size)
  end

  it "should be invalid with a negative size" do
    @image.size = -1
    @image.should_not be_valid
    @image.should have(1).error_on(:size)
  end

  it "should be invalid with a non-numeric width" do
    @image.width = 'xyz'
    @image.should_not be_valid
    @image.should have(1).error_on(:width)
  end

  it "should be invalid with a negative width" do
    @image.width = -1
    @image.should_not be_valid
    @image.should have(1).error_on(:width)
  end

  it "should be invalid with a non-numeric height" do
    @image.height = 'xyz'
    @image.should_not be_valid
    @image.should have(1).error_on(:height)
  end

  it "should be invalid with a negative height" do
    @image.height = -1
    @image.should_not be_valid
    @image.should have(1).error_on(:height)
  end

end
