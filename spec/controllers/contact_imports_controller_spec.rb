require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactImportsController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :new, :edit, :destroy, :show, :index, :create, :update, :revert
  it_should_be_inherited_resource

  before(:each) do
    sign_in_quentin
  end

  def mock_contact_import(stubs={})
    (@mock_contact_import ||= mock_model(ContactImport).as_null_object).tap do |contact_import|
      contact_import.stub(stubs) unless stubs.empty?
    end
  end

  describe "POST revert" do
    before(:each) do
      mock_contact_import.should_receive(:revert!).and_return(true)
      ContactImport.stub(:find).with("6") { mock_contact_import }
    end
    
    it "call revert on desired contact_import" do
      post :revert, :id => "6"
      assigns(:contact_import).should be(mock_contact_import)
    end
    
    it "redirects to the reverted contact_import" do
      post :revert, :id => "6"
      response.should redirect_to(contact_import_url(mock_contact_import))
    end
  end
end
