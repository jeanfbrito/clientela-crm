require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DealsController do
  it_should_respond_to :html, :xml, :json
  # it_should_have_actions :new, :edit, :destroy, :show, :index, :create, :update, :prospect, :qualify, :proposal, :negotiation, :won, :lost
  it_should_be_inherited_resource

  before(:each) do
    sign_in_quentin
  end

  describe "GET prospect" do
    before do
      get :prospect
    end

    it { assigns(:deals).should_not be_nil }
    it { should render_template(:index) }
  end
  describe "GET qualify" do
    before do
      get :qualify
    end

    it { assigns(:deals).should_not be_nil }
    it { should render_template(:index) }
  end
  describe "GET proposal" do
    before do
      get :proposal
    end

    it { assigns(:deals).should_not be_nil }
    it { should render_template(:index) }
  end
  describe "GET negotiation" do
    before do
      get :negotiation
    end

    it { assigns(:deals).should_not be_nil }
    it { should render_template(:index) }
  end
  describe "GET won" do
    before do
      get :won
    end

    it { assigns(:deals).should_not be_nil }
    it { should render_template(:index) }
  end
  describe "GET lost" do
    before do
      get :lost
    end

    it { assigns(:deals).should_not be_nil }
    it { should render_template(:index) }
  end

  describe "GET index" do
    before(:each) do
      get :index
    end

    it "assigns deals to @deals" do
      assigns(:wons).should == []
      assigns(:losts).should == []
      assigns(:pendings).should == []
    end

    it "render index template" do
      response.should render_template(:index)
    end
  end
end
