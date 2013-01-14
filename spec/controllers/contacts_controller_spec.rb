require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactsController do
  it_should_respond_to :html, :xml, :json
  # it_should_have_actions :_callback_before_967, :new, :edit, :destroy, :show, :index, :create, :update, :autocomplete_contact_name, :autocomplete_contact_title, :autocomplete_company_name
  it_should_be_inherited_resource

  before(:each) do
    sign_in_quentin
  end

  def mock_contact(stubs={})
    @mock_contact ||= mock_model(Contact, stubs).as_null_object
  end

  describe "autocompletes" do
    describe "GET autocomplete_contact_name" do
      it "respond to" do
        get :autocomplete_contact_name, :term => "don"
        response.body.should == "[]"
      end
    end
    
    describe "GET autocomplete_contact_title" do
      it "should query Contact and render json" do
        Contact.should_receive(:autocomplete_title).with("don").and_return([])
        get :autocomplete_contact_title, :term => "don"
        response.body.should == "[]"
      end
    end
  end

  describe "GET index" do
    let!(:owner) { FactoryGirl.create(:tag_owner) }
    before do
      @group = Group.create!(:name => "My group")

      @user = User.last
      @user.groups << @group

      @contact_joseph = FactoryGirl.create(:contact_joseph, imported_by: nil)
      @note = FactoryGirl.create(:note_quentin, notable: @contact_joseph)
      @contact_joseph.permissions.create!(:group => @group)
      @contact = FactoryGirl.create(:contact_quentin)
      @tag = FactoryGirl.create(:tag_owner_quentin, tag_id: owner.id, taggable_id: @contact.id)
      @contact.permissions.create!(:group => @group)
    end
    
    it "assigns all contacts as @contacts" do
      get :index
      assigns(:contacts).size.should == 2
    end
    
    it "should filter by initials" do
      get :index, :initial => "Jo"
      assigns(:contacts).should eq([@contact_joseph])
    end
    
    it "should filter by tag" do
      ActsAsTaggableOn::Tag.should_receive(:find).with("44-customer").and_return('tag-mock')
      Contact.should_receive(:tagged_with).with('tag-mock') { [mock_contact] }

      get :index, :tag_id => "44-customer"
      assigns(:contacts).should eq([mock_contact])
    end
  end
end
