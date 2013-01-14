require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do
  render_views
  let!(:account) { FactoryGirl.create(:example, goal_quantitative: 1, goal_qualitative: 1) }

  before(:each) do
    sign_in_quentin
    controller.should_receive(:current_account).any_number_of_times.and_return(account)
  end

  describe "GET index" do
    before(:each) do
      get :index, :date => { :year => "2011" }
    end

    it "should assign @year" do
      assigns(:year).should == 2011
    end
  end

  describe "charts" do
    context "valid year" do
      before(:each) do
        controller.instance_variable_set(:@year, 2011)
      end

      describe "quantitative_chart" do
        it "should generate google chart" do
          controller.send(:quantitative_chart).should be_instance_of(GoogleVisualr::Interactive::BarChart)
        end
      end

      describe "qualitative_chart" do
        it "should generate google chart" do
          controller.send(:qualitative_chart).should be_instance_of(GoogleVisualr::Interactive::BarChart)
        end
      end      
    end

    context "invalid year" do
      before(:each) do
        controller.instance_variable_set(:@year, 2009)
      end

      describe "quantitative_chart" do
        it "should generate max equal to 1" do
          controller.send(:quantitative_chart).options["hAxis"][:viewWindow][:max].should == 1
        end
      end

      describe "qualitative_chart" do
        it "should generate max equal to 1" do
          controller.send(:qualitative_chart).options["hAxis"][:viewWindow][:max].should == 1
        end
      end 
    end
  end
end