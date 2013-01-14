require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubscriptionsController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :create, :destroy
  #it_should_be_inherited_resource

  let!(:contact) { FactoryGirl.create(:contact_joseph, imported_by: nil) }

  before(:each) do
    sign_in_quentin

    @user = User.last
  end

  def mock_subscription(stubs={})
    (@mock_subscription ||= mock_model(Subscription).as_null_object).tap do |subscription|
      subscription.stub(stubs) unless stubs.empty?
    end
  end

  describe "POST create" do
    {:contact => :contact_quentin, :company => :company_helabs, :deal => :quentin_deal_won, :fact => :fact}.each do |model, subject|
      subject_id = "#{model.to_s}_id".to_sym

      describe "with valid params when nested with #{model}" do
        before(:each) do
          @subject = FactoryGirl.send("create", subject)
        end

        it "assigns a newly created subscription as @subscription" do
          lambda do
            post :create, subject_id => @subject.id
          end.should change(Subscription, :count).by(1)

          assigns(:subscription).subscriber.should eql(@user)
          assigns(:subscription).subject.should eql(@subject)
        end

        it "redirects to the created subscription" do
          post :create, subject_id => @subject.id
          response.should redirect_to(@subject)
        end
      end
    end

    describe "with valid params when nested with contact" do
      it "assigns a newly created subscription as @subscription" do
        lambda do
          post :create, :contact_id => contact.id
        end.should change(Subscription, :count).by(1)

        assigns(:subscription).subscriber.should eql(@user)
        assigns(:subscription).subject.should eql(contact)
      end

      it "redirects to the created subscription" do
        post :create, :contact_id => contact.id
        response.should redirect_to(contact_url(contact))
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      Subscription.create!(:subscriber => @user, :subject => contact)
    end

    it "redirects to the subscriptions list" do
      lambda do
        delete :destroy, :contact_id => contact.id
      end.should change(Subscription, :count).by(-1)
      response.should redirect_to(contact_url(contact))
    end
  end

end
