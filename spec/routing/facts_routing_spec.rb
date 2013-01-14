require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FactsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/facts" }.should route_to(:controller => "facts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/facts/new" }.should route_to(:controller => "facts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/facts/1" }.should route_to(:controller => "facts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/facts/1/edit" }.should route_to(:controller => "facts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/facts" }.should route_to(:controller => "facts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/facts/1" }.should route_to(:controller => "facts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/facts/1" }.should route_to(:controller => "facts", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #closed" do
      { :get => "/facts/closed" }.should route_to(:controller => "facts", :action => "closed")
    end
  end
end
