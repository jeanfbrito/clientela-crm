require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RelationshipsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/relationships" }.should_not be_routable
    end

    it "recognizes and generates #new" do
      { :get => "/relationships/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/relationships" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/relationships/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/relationships" }.should route_to(:controller => "relationships", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/relationships" }.should_not be_routable
    end

    it "recognizes and generates #destroy" do
      { :delete => "/relationships/1" }.should route_to(:controller => "relationships", :action => "destroy", :id => "1")
    end
  end
end
