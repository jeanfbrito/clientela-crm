require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksController do
  describe "routing" do
    it "recognizes and generates #new" do
      { :get => "/task_categories/new" }.should route_to(:controller => "task_categories", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/task_categories" }.should route_to(:controller => "task_categories", :action => "create")
    end

    it "recognizes and generates #edit" do
      { :get => "/task_categories/1/edit" }.should route_to(:controller => "task_categories", :action => "edit", :id => '1')
    end

    it "recognizes and generates #update" do
      { :put => "/task_categories/1" }.should route_to(:controller => "task_categories", :action => "update",  :id => '1')
    end

    it "should not route to #index" do
      { :get => "/task_categories" }.should_not be_routable
    end

    it "should not route to #show" do
      { :get => "/task_categories/1" }.should_not be_routable
    end

    it "should not route to #destroy" do
      { :delete => "/task_categories/1" }.should_not be_routable
    end
  end
end
