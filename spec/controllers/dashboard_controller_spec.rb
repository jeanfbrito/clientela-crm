require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  before(:each) do
    sign_in_quentin
  end

  describe "funnel_chart" do
    let!(:deal) { FactoryGirl.create(:quentin_deal_won) }
    let!(:deal2) { FactoryGirl.create(:quentin_deal_lost) }
    it "should return funnel_chart" do
      controller.send(:funnel_chart).should_not be_nil
    end
  end

  describe "GET show" do
    it "should assign @activities" do
      get :show
      assigns(:activities).should == Activity.latest
    end

    it "render template" do
      get :show
      response.should render_template(:show)
    end
  end

  describe "helpers" do
    describe "previous_date" do
      it "should return date to previous link" do
        Timecop.freeze(2011, 8, 10) do
          controller.send(:previous_date).should == Date.new(2011,8,1)
        end
      end
    end

    describe "next_date" do
      it "should return date to previous link" do
        Timecop.freeze(2011, 8, 10) do
          controller.send(:next_date).should == Date.new(2011,8,15)
        end
      end
    end
  end
end
