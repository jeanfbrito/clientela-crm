require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MenusController do
  def mock_menu(stubs={})
    (@mock_menu ||= mock_model(Menu).as_null_object).tap do |menu|
      menu.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    sign_in_quentin
    request.env["HTTP_REFERER"] = '/back'
  end

  describe "POST create" do
    it "assigns a newly created menu as @menu" do
      Menu.should_receive(:create).with({'these' => 'params'}) { mock_menu }
      post :create, :menu => {'these' => 'params'}
      assigns(:menu).should be(mock_menu)
    end

    it "redirects to the created menu" do
      Menu.stub(:new) { mock_menu(:save => true) }
      post :create, :menu => {}
      response.should redirect_to('http://test.host/back')
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested menu" do
      Menu.should_receive(:find).with("37") { mock_menu }
      mock_menu.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the menus list" do
      Menu.stub(:find) { mock_menu }
      delete :destroy, :id => "1"
      response.should redirect_to('http://test.host/back')
    end
  end
end
