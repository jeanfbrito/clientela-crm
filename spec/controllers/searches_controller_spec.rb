require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchesController do
  let!(:account) { FactoryGirl.create(:dummy) }
  before(:each) do
    sign_in_quentin
  end

  describe "GET show" do
    it "should call thinking sphinx with account filter" do
      ThinkingSphinx.should_receive(:search).with('item-to-search', :retry_stale=>true).and_return([])
      get :show, :q => "item-to-search"
      assigns(:searches).should == []
    end

    it "should render show " do
      ThinkingSphinx.stub!(:search).and_return([])
      get :show, :q => "item-to-search"
      response.should render_template("show")
    end
    
    it "should redirect to item if only one is found" do
      contact = FactoryGirl.create(:contact_joseph, imported_by: nil)
      
      ThinkingSphinx.stub!(:search).and_return([contact])
      get :show, :q => "item-to-search"
      response.should redirect_to(contact)
    end
  end
end
