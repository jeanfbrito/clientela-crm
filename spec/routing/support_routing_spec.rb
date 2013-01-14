require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SupportController do
  describe "routing" do
    it "recognizes and generates #api" do
      { :get => "/support/api" }.should route_to(:controller => "support", :action => "api")
    end
  end
end
