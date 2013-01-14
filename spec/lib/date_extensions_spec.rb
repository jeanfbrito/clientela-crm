require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DateExtensions do
  describe "this_week" do
    it "should return this week friday" do
      Timecop.freeze(2011,10,5) do
        Date.this_week.should == Date.new(2011,10,7)
      end
    end
  end

  describe "next_week" do
    it "should return next week friday" do
      Timecop.freeze(2011,10,5) do
        Date.next_week.should == Date.new(2011,10,14)
      end
    end
  end
end