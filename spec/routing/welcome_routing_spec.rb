require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController do
  describe "routing" do
    it "recognizes and generates #show" do
      { :get => "/welcome" }.should route_to(:controller => "welcome", :action => "show")
    end

    it "recognizes and generates #new" do
      { :get => "/welcome/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/welcome/1" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/welcome/1/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/welcome" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/welcome" }.should route_to(:controller => "welcome", :action => "update")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/welcome/1" }.should_not be_routable
    end
  end
end
