require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RelationshipsController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :create, :destroy
  it_should_be_inherited_resource

  before(:each) do
    sign_in_quentin
  end

  let!(:deal) { FactoryGirl.create(:quentin_deal_won) }
  let!(:contact) { FactoryGirl.create(:contact_joseph, imported_by: nil) }

  describe "POST create" do
    it "redirects back to the entity page" do
      post :create, :relationship => {:entity_id => deal.id, :entity_type => 'Deal', :contact_id => contact.id}
      response.should redirect_to(deal)
    end
  end

  describe "DELETE destroy" do
    it "redirects back to the entity page" do
      rel = Relationship.create!(:entity => deal, :contact => contact)

      delete :destroy, :id => rel.id
      response.should redirect_to(deal)
    end
  end
end
