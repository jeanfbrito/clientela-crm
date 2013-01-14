require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactsHelper do
  describe "initials?" do
    it "should return false when there is params[:scope]" do
      helper.stub!(:params).and_return({:scope => 1})
      helper.initials?.should be_false
    end

    it "should return false when there is params[:tag_id]" do
      helper.stub!(:params).and_return({:tag_id => 1})
      helper.initials?.should be_false
    end

    it "should return true when there is no scope or tag_id" do
      helper.stub!(:params).and_return({})
      helper.initials?.should be_true
    end
  end
end