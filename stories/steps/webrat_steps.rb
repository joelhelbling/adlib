steps_for(:webrat) do
  
  When "I visit '$path'" do |path|
    visits path
  end
  
  When "fill in $field with '$value'" do |field, value|
    fills_in field, :with => value
  end
  
  When "click the $button button" do |button|
    clicks_button button
  end

  Then "I should be on the page '$path'" do |path|
    path.should == path
  end

  Then "I should see the error '$message'" do |message|
    response.should have_tag('.error', message) 
  end

end