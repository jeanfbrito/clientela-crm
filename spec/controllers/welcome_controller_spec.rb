require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController do
  before(:each) do
    sign_in_quentin
  end

  describe "GET show" do
    it "should render show" do
      get :show
      response.should render_template("show")
    end

    it "should redirect to dashboard" do
      User.last.toggle!(:welcome)
      get :show
      response.should redirect_to(root_url)
    end
  end

  describe "PUT update" do
    it "should toggle welcome on users" do
      @user = User.last
      @user.should_receive(:toggle!).with(:welcome).and_return(true)
      controller.stub!(:current_user).and_return(@user)

      put :update
      response.should redirect_to(root_url)
    end
  end
end
