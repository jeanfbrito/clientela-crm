require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuantitativeReport do
  before(:each) do
   @report = QuantitativeReport.new
  end

  describe "when there isn't a period" do
    it "should return a [[]]" do
      @report.data.should == [[]]
    end
  end
end