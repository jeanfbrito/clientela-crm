require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubscriptionsController do
  describe "routing" do

    [:contact, :company, :deal, :fact].each do |model|
      plural = model.to_s.pluralize
      model_id = "#{model.to_s}_id".to_sym

      describe "nested on #{plural}" do
        it "recognizes and generates #new" do
          { :get => "/#{plural}/1/subscription/new" }.should_not be_routable
        end

        it "recognizes and generates #show" do
          { :get => "/#{plural}/1/subscription" }.should_not be_routable
        end

        it "recognizes and generates #edit" do
          { :get => "/#{plural}/1/subscription/edit" }.should_not be_routable
        end

        it "recognizes and generates #update" do
          { :put => "/#{plural}/1/subscription" }.should_not be_routable
        end

        it "recognizes and generates #create" do
          { :post => "/#{plural}/1/subscription" }.should route_to(:controller => "subscriptions", :action => "create", model_id => "1")
        end

        it "recognizes and generates #destroy" do
          { :delete => "/#{plural}/1/subscription" }.should route_to(:controller => "subscriptions", :action => "destroy", model_id => "1")
        end
      end
    end

    it "recognizes and generates #index" do
      { :get => "/subscriptions" }.should_not be_routable
    end

    it "recognizes and generates #new" do
      { :get => "/subscriptions/new" }.should_not be_routable
    end

    it "recognizes and generates #show" do
      { :get => "/subscriptions/1" }.should_not be_routable
    end

    it "recognizes and generates #edit" do
      { :get => "/subscriptions/1/edit" }.should_not be_routable
    end

    it "recognizes and generates #create" do
      { :post => "/subscriptions" }.should_not be_routable
    end

    it "recognizes and generates #update" do
      { :put => "/subscriptions/1" }.should_not be_routable
    end

    it "recognizes and generates #destroy" do
      { :delete => "/subscriptions/1" }.should_not be_routable
    end

  end
end
