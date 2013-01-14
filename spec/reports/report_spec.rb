require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Report do
  before(:each) do
   @report = Report.new(nil)
  end

  describe "when try use this class" do
    it "shoud raise NotImplementedError" do
      lambda do 
        @report.data
      end.should raise_error(NotImplementedError)
    end
  end
end