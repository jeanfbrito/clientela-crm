require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactImportsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/contact_imports" }.should route_to(:controller => "contact_imports", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/contact_imports/new" }.should route_to(:controller => "contact_imports", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/contact_imports/1" }.should route_to(:controller => "contact_imports", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/contact_imports/1/edit" }.should route_to(:controller => "contact_imports", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/contact_imports" }.should route_to(:controller => "contact_imports", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/contact_imports/1" }.should route_to(:controller => "contact_imports", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/contact_imports/1" }.should route_to(:controller => "contact_imports", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #revert" do
      { :post => "/contact_imports/1/revert" }.should route_to(:controller => "contact_imports", :action => "revert", :id => "1")
    end
  end
end
