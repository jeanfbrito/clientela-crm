require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/users" }.should route_to(:controller => "users", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/users/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/users/1" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/users/1/edit" }.should route_to(:controller => "users", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/users" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/users/1" }.should route_to(:controller => "users", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/users/1" }.should route_to(:controller => "users", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #update_authentication_token" do
      { :put => "/users/1/update_authentication_token" }.should route_to(:controller => "users", :action => "update_authentication_token", :id => "1")
    end
    
    it "recognizes and generates #survey" do
      { :put => "/users/survey" }.should route_to(:controller => "users", :action => "survey")
    end
  end
end
