require 'spec_helper'

describe GroupsController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :new, :edit, :destroy, :index, :create, :update
  it_should_be_inherited_resource
  xit "pending control to only give access do admin"

  describe "collection" do
    it "should return collection" do
      controller.send(:collection).should == []
    end
  end

  describe "fix_params" do
    it "should set user_ids" do
      controller.params[:group] = {}
      controller.send(:fix_params)
      controller.params[:group][:user_ids].should == []
    end
  end
end
