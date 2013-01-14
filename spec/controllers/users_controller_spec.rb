require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :edit, :destroy, :index, :update, :update_authentication_token, :survey
  it_should_be_inherited_resource

  before(:each) do
    controller.stub!(:set_current_user).and_return(true)
    controller.stub!(:authenticate_user!).and_return(true)
    controller.stub!(:set_current_user_time_zone).and_return(true)
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  describe "GET index" do
    it "should render index" do
      User.should_receive(:active).and_return(['users'])
      get :index
      assigns(:users).should == ['users']
      response.should render_template("index")
    end
  end

  describe "GET edit" do
    before(:each) do
      controller.stub!(:current_user).and_return(mock_model(User, :id => 37))
    end

    it "assigns the requested user as @user" do
      User.stub(:find).with("37") { mock_user }
      get :edit, :id => "37"
      assigns(:user).should be(mock_user)
    end

    it "should not allow edit another user" do
      User.should_receive(:find).with(false).and_raise(ActiveRecord::RecordNotFound)
      lambda do
        get :edit, :id => "1"
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "PUT update" do
    before(:each) do
      controller.stub!(:current_user).and_return(mock_model(User, :id => 37))
    end

    it "should not allow update another user" do
      User.should_receive(:find).with(false).and_raise(ActiveRecord::RecordNotFound)
      lambda do
        put :update, :id => "1", :user => {'these' => 'params'}
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "redirects to the user" do
      User.stub(:find) { mock_user(:update_attributes => true) }
      put :update, :id => "1"
      response.should redirect_to(edit_user_url(mock_user))
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      controller.stub!(:current_user).and_return(mock_model(User, :id => 1, :admin? => true))
    end

    it "should be unable to delete itself" do
      User.should_receive(:find).with(false).and_raise(ActiveRecord::RecordNotFound)
      lambda do
        delete :destroy, :id => "1"
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "destroys the requested user" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the users list" do
      User.stub(:find) { mock_user }
      delete :destroy, :id => "1"
      response.should redirect_to(users_url)
    end

    it "should not allow a non admin to delete a user" do
      controller.stub!(:current_user).and_return(mock_model(User, :id => 37, :admin? => false))
      lambda do
        delete :destroy, :id => "37"
      end.should raise_error(ActionController::UnknownAction)
    end
  end

  describe "PUT update_authentication_token" do
    before(:each) do
      controller.stub!(:current_user).and_return(mock_user(:id => 37))
    end

    it "it should reset authentication code and redirect" do
      controller.current_user.should_receive(:reset_authentication_token!)
      put :update_authentication_token, :id => 'no-matter'
      response.should redirect_to(edit_user_url(37))
    end
  end

  describe "PUT survey" do
    before(:each) do
      controller.stub!(:current_user).and_return(mock_user(:id => 37))
    end

    it "should save survey hash on current user" do
      mock_user.should_receive(:update_survey).with({"interface"=>"new"})
      put :survey, :survey => {'interface' => 'new'}
      response.should be_success
    end
  end
end
