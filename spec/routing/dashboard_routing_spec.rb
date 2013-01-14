require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  describe "routing" do
    it "recognizes and generates #show" do
      { :get => "/dashboard" }.should_not be_routable
      { :get => "/" }.should route_to(:controller => "dashboard", :action => "show")
      root_path.should == '/'
    end

    it "recognizes and generates #new" do
      { :get => "/dashboard/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/dashboard/1" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/dashboard/1/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/dashboard" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/dashboard/1" }.should_not be_routable
    end

    it "recognizes and generates #destroy" do
      { :delete => "/dashboard/1" }.should_not be_routable
    end
  end
end
