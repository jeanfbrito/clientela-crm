require 'spec_helper'

describe TaskCategoriesController do
  it_should_respond_to :js
  it_should_have_actions :new, :create, :edit, :update
  it_should_be_inherited_resource
  
  before(:each) do
    sign_in_quentin
    request.env["HTTP_REFERER"] = '/back'
  end

  describe "PUT update" do
    describe "valid attribute" do
      it "should redirects back" do
        TaskCategory.stub(:find) { mock_model(TaskCategory, :update_attributes => true) }
        put :update, :id => "37" 
        response.should redirect_to("/back")
      end
    end
  end

  describe "POST create" do
    describe "valid attribute" do
      it "should redirects back" do
        TaskCategory.stub(:new) { mock_model(TaskCategory,:save => true) }
        post :create, :task_category => {}
        response.should redirect_to("/back")
      end
    end
  end
end