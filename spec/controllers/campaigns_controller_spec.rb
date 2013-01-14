require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CampaignsController do
  before(:each) do
    sign_in_quentin
  end
  
  def mock_campaign(stubs={})
    @mock_campaign ||= mock_model(Campaign, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all campaigns as @campaigns" do
      Campaign.stub(:all) {[mock_campaign]}
      get :index
      assigns(:campaigns).should eq([mock_campaign])
    end
  end

  describe "GET show" do
    it "assigns the requested campaign as @campaign" do
      Campaign.stub(:find).with("42") { mock_campaign }
      get :show, :id => "42"
      assigns(:campaign).should be(mock_campaign)
    end
  end
  
  describe "GET new" do
    it "assigns a new campaign as @campaign" do
      Campaign.stub(:new) { mock_campaign }
      get :new
      assigns(:campaign).should be(mock_campaign)
    end
  end

  describe "GET edit" do
    it "assigns the requested campaign as @campaign" do
      Campaign.stub(:find).with("42") { mock_campaign }
      get :edit, :id => "42"
      assigns(:campaign).should be(mock_campaign)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created campaign as @campaign" do
        Campaign.stub(:new).with({'these' => 'params'}) { mock_campaign(:save => true) }
        post :create, :campaign => {'these' => 'params'}
        assigns(:campaign).should be(mock_campaign)
      end

      it "redirects to the created campaign" do
        Campaign.stub(:new) { mock_campaign(:save => true) }
        post :create, :campaign => {}
        response.should redirect_to(campaign_url(mock_campaign))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved campaign as @campaign" do
        Campaign.stub(:new).with({'these' => 'params'}) { mock_campaign(:save => false) }
        post :create, :campaign => {'these' => 'params'}
        assigns(:campaign).should be(mock_campaign)
      end

      it "re-renders the 'new' template" do
        Campaign.stub(:new) { mock_campaign(:save => false) }
        post :create, :campaign=> {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested campaign" do
        Campaign.should_receive(:find).with("42") { mock_campaign }
        mock_campaign.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "42", :campaign => {'these' => 'params'}
      end

      it "assigns the requested campaign as @campaign" do
        Campaign.stub(:find) { mock_campaign(:update_attributes => true) }
        put :update, :id => "42"
        assigns(:campaign).should be(mock_campaign)
      end

      it "redirects to the contact" do
        Campaign.stub(:find) { mock_campaign(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(campaign_url(mock_campaign))
      end
    end

    describe "with invalid params" do
      it "assigns the campaign as @campaign" do
        Campaign.stub(:find) { mock_campaign(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:campaign).should be(mock_campaign)
      end

      it "re-renders the 'edit' template" do
        Campaign.stub(:find) { mock_campaign(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested campaign" do
      Campaign.should_receive(:find).with("37") { mock_campaign }
      mock_campaign.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the campaign list" do
      Campaign.stub(:find) { mock_campaign }
      delete :destroy, :id => "1"
      response.should redirect_to(campaigns_url)
    end
  end
end