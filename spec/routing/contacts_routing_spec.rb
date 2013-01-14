require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactsController do
  describe "routing" do
    it "recognizes and generates #autocomplete_contact_name" do
      { :get => "/contacts/autocomplete_contact_name" }.should route_to(:controller => "contacts", :action => "autocomplete_contact_name")
    end
    
    it "recognizes and generates #autocomplete_contact_title" do
      { :get => "/contacts/autocomplete_contact_title" }.should route_to(:controller => "contacts", :action => "autocomplete_contact_title")
    end

    it "recognizes and generates #autocomplete_contact_company" do
      { :get => "/contacts/autocomplete_company_name" }.should route_to(:controller => "contacts", :action => "autocomplete_company_name")
    end
    
    it "recognizes and generates #index" do
      { :get => "/contacts" }.should route_to(:controller => "contacts", :action => "index")
    end

    it "recognizes and generates nested tags #index" do
      { :get => "/tags/client/contacts" }.should route_to(:controller => "contacts", :action => "index", :tag_id => "client")
    end

    it "recognizes and generates #new" do
      { :get => "/contacts/new" }.should route_to(:controller => "contacts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/contacts/1" }.should route_to(:controller => "contacts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/contacts/1/edit" }.should route_to(:controller => "contacts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/contacts" }.should route_to(:controller => "contacts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/contacts/1" }.should route_to(:controller => "contacts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/contacts/1" }.should route_to(:controller => "contacts", :action => "destroy", :id => "1")
    end
  end
end
