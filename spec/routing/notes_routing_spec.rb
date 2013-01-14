require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NotesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/notes" }.should_not be_routable
    end

    it "recognizes and generates #new" do
      { :get => "/notes/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/notes/1" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/notes/1/edit" }.should route_to(:controller => "notes", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/notes" }.should route_to(:controller => "notes", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/notes/1" }.should route_to(:controller => "notes", :action => "update", :id => "1")
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/notes/1" }.should route_to(:controller => "notes", :action => "destroy", :id => "1")
    end
  end
end
