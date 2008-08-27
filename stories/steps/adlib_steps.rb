steps_for(:adlib) do

  Given "I am logged into adlib as '$username' with password '$password'" do |username, password|
    @adlib_user = AdlibUser.find_by_username(username)
    @adlib_user.should_not be_nil
    post '/adlib/login', :adlib_user => {:username => username, :password => password}
    controller.session[:adlib_user_id].should == @adlib_user.id
  end

  Given "I am not logged into adlib" do
    get '/adlib/logout' 
    controller.session[:adlib_user_id].should be_nil 
  end

  Then "I should be logged into adlib as '$username'" do |username|
    controller.session[:adlib_user_id].should_not be_nil
    AdlibUser.find(controller.session[:adlib_user_id]).username.should == username
  end

  Then "I should not be logged into adlib" do
    controller.session[:adlib_user_id].should be_nil 
  end

end