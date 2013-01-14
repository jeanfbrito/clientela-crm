require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchesController do
  describe "routing" do
    it "recognizes and generates #new" do
      { :get => "/search/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/search" }.should route_to(:controller => "searches", :action => "show")
    end

    it "recognizes and generates #edit" do
      { :get => "/search/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/search" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/search" }.should_not be_routable
    end

    it "recognizes and generates #destroy" do
      { :delete => "/search" }.should_not be_routable
    end
  end
end
