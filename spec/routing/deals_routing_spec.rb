require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DealsController do
  describe "routing" do
    it "recognizes and generates #won" do
      { :get => "/deals/won" }.should route_to(:controller => "deals", :action => "won")
    end
    it "recognizes and generates #lost" do
      { :get => "/deals/lost" }.should route_to(:controller => "deals", :action => "lost")
    end
    it "recognizes and generates #negotiation" do
      { :get => "/deals/negotiation" }.should route_to(:controller => "deals", :action => "negotiation")
    end
    it "recognizes and generates #proposal" do
      { :get => "/deals/proposal" }.should route_to(:controller => "deals", :action => "proposal")
    end
    it "recognizes and generates #qualify" do
      { :get => "/deals/qualify" }.should route_to(:controller => "deals", :action => "qualify")
    end
    it "recognizes and generates #prospect" do
      { :get => "/deals/prospect" }.should route_to(:controller => "deals", :action => "prospect")
    end

    it "recognizes and generates #index" do
      { :get => "/deals" }.should route_to(:controller => "deals", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/deals/new" }.should route_to(:controller => "deals", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/deals/1" }.should route_to(:controller => "deals", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/deals/1/edit" }.should route_to(:controller => "deals", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/deals" }.should route_to(:controller => "deals", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/deals/1" }.should route_to(:controller => "deals", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/deals/1" }.should route_to(:controller => "deals", :action => "destroy", :id => "1")
    end
  end
end