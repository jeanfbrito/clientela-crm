require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsController do
  before(:each) do
    sign_in_quentin
  end

  def mock_tag(stubs={})
    @mock_tag ||= mock_model(ActsAsTaggableOn::Tag, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all tags as @tags" do
      get :index
      assigns(:first_half).should_not be_nil
    end
  end

  describe "GET show" do
    it "should assing contacts" do
      ActsAsTaggableOn::Tag.should_receive(:find).with("44-customer").and_return('tag-mock')
      Contact.should_receive(:tagged_with).with('tag-mock') { mock_tag }

      get :show, :id => "44-customer"
      assigns(:contacts).should be(mock_tag)
    end

    it "should assing deals" do
      ActsAsTaggableOn::Tag.should_receive(:find).with("44-customer").and_return('tag-mock')
      Deal.should_receive(:tagged_with).with('tag-mock') { mock_tag }

      get :show, :id => "44-customer"
      assigns(:deals).should be(mock_tag)
    end
  end
end