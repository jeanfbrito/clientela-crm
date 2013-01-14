require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Email do
  should_validate_presence_of :address
  should_validate_presence_of :kind
  
  should_belong_to :entity

  describe "kinds" do
    it "should return email kind" do
      Email.kinds.should == [:work, :home, :other]
    end
  end
end
