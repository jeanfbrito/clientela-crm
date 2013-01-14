require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  controller do
    def index
      render :text => "index"
    end
  end

  let!(:account) { FactoryGirl.create(:example) }

  describe "current_account" do
    context "when account is found" do
      before do
        Account.should_receive(:first).and_return account
        controller.send(:current_account)
      end

      it { assigns(:current_account).should eq account }
    end
  end

  describe "current_user thread trick" do
    describe "when there is a signed in user" do
      before(:each) do
        sign_in_quentin
      end

      it "should set on Thread.current[:current_user] the current user id" do
        Thread.current[:current_user] = nil
        lambda do
          get :index
        end.should change(self, :thread_current_user).from(nil).to(User.last.id)
      end
    end

    describe "when there is no signed in user" do
      before(:each) do
        sign_out :user
      end

      it "should not set Thread.current[:current_user]" do
        get :index
        thread_current_user.should be_nil
      end
    end

    def thread_current_user
      Thread.current[:current_user]
    end
  end

  describe "set user timezone" do
    it "should set timezone from user" do
      brasilia = ActiveSupport::TimeZone['Brasilia']
      utc = ActiveSupport::TimeZone['UTC']
      sign_in_quentin

      lambda do
        get :index
      end.should change(Time, :zone).from(utc).to(brasilia)
    end

    it "should not set timezone if no user is logged in" do
      controller.should_receive(:current_user).and_return(nil)
      lambda do
        controller.send(:set_current_user_time_zone)
      end.should_not raise_exception
    end
  end

  describe "Cancan error handle" do
    controller do
      def index
        raise CanCan::AccessDenied
      end
    end

    before do
      sign_in_quentin
      get :index
    end

    it { should render_template("public/401.html") }
    it { response.code.should == "401" }
  end
end
