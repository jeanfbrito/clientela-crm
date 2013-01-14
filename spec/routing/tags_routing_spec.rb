require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/tags" }.should route_to(:controller => "tags", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/tags/new" }.should route_to(:controller => "tags", :action => "show", :id => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tags/1" }.should route_to(:controller => "tags", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tags/1/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/tags" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/tags/1" }.should_not be_routable
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/tags/1" }.should_not be_routable
    end
  end
end
