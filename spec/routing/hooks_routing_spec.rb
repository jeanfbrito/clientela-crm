require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HooksController do
  describe "routing" do
    it "recognizes and generates #wufoo" do
      { :post => "/hooks/wufoo" }.should route_to(:controller => "hooks", :action => "wufoo")
      { :get => "/hooks/wufoo" }.should_not be_routable
      { :put => "/hooks/wufoo" }.should_not be_routable
      { :delete => "/hooks/wufoo" }.should_not be_routable
    end
  end
end
