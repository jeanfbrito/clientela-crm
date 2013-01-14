require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvitationsController do

  describe "after_invite_path_for" do
    it "should return users url" do
      controller.send(:after_invite_path_for, nil).should == users_url
    end
  end

  describe "choose_layout" do
    it "should return application template to new and create" do
      controller.stub!(:action_name).and_return("new")
      controller.send(:choose_layout).should == "application"

      controller.stub!(:action_name).and_return("create")
      controller.send(:choose_layout).should == "application"
    end

    it "should return users/invitations template to edit and update" do
      controller.stub!(:action_name).and_return("edit")
      controller.send(:choose_layout).should == "invitations"

      controller.stub!(:action_name).and_return("update")
      controller.send(:choose_layout).should == "invitations"
    end
  end
end
