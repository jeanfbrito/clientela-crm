require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FactsController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :new, :edit, :closed, :destroy, :show, :index, :create, :update
  it_should_be_inherited_resource
  
  before(:each) do
    sign_in_quentin
  end

  def mock_fact(stubs={})
    (@mock_fact ||= mock_model(Fact).as_null_object).tap do |fact|
      fact.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET closed" do
    before(:each) do
      Fact.should_receive(:closed).and_return([mock_fact])
      get :closed
    end

    it "assigns closed facts" do
      assigns(:facts).should == [mock_fact]
    end

    it "render index template" do
      response.should render_template(:index)
    end
  end

  describe "GET index" do
    it "assigns opened facts as @facts" do
      Fact.stub(:opened) { [mock_fact] }
      get :index
      assigns(:facts).should eq([mock_fact])
    end
  end
end
