require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksController do
  it_should_respond_to :html, :xml, :json
  it_should_have_actions :index, :edit, :create, :update, :completed, :complete, :destroy, :new
  it_should_be_inherited_resource

  let!(:task_today_done) { FactoryGirl.create(:task_today_done) }
  let!(:task_yesterday_done) { FactoryGirl.create(:task_yesterday_done) }
  let!(:task_tomorrow_done) { FactoryGirl.create(:task_tomorrow_done) }
  let(:user) { User.last }

  before(:each) do
    sign_in_quentin
  end

  def mock_task(stubs={})
    @mock_task ||= mock_model(Task, stubs).as_null_object
  end

  describe "GET completed" do
    before(:each) do
      Task.should_receive(:completed).and_return([task_today_done, task_yesterday_done, task_tomorrow_done])
      get :completed
    end

    it "assigns completed tasks to @completed" do
      assigns(:tasks).should == [task_today_done, task_yesterday_done, task_tomorrow_done]
    end

    it "render completed tasks template" do
      response.should render_template(:completed)
    end
  end

  describe "PUT complete" do
    before(:each) do
      Task.should_receive(:find).with("1") { mock_task }
      mock_task.should_receive(:complete)
    end

    it "should completes the requested task" do
      put :complete, :id => "1"
    end

    it "should render nothing" do
      put :complete, :id => "1"
      response.body.should be_blank
    end
  end

  describe "GET edit" do
    it "assigns the requested task as @task" do
      Task.stub(:find).with("37") { mock_task }
      get :edit, :id => "37", :format => :js
      assigns(:task).should be(mock_task)
    end
  end

  describe "POST create" do
    before(:each) do
      request.env["HTTP_REFERER"] = '/back'
    end

    describe "with valid params" do
      it "should redirects back" do
        Task.stub(:new) { mock_task(:save => true) }
        post :create, :task => {}
        response.should redirect_to("/back")
      end

      it "sets assigned_to to the corresponding user if params[:assigned_to_id] is present" do
        mock_task(:taskable_id => false)
        Task.should_receive(:new).with('these' => 'params', 'assigned_to_id' => 666, 'created_by' => user).and_return(mock_task)

        post :create, :task => {'these' => 'params', 'assigned_to_id' => 666}
        assigns(:task).should be(mock_task)
      end

      it "sets assigned_to to the current_user if params[:assigned_to_id] is blank" do
        mock_task(:taskable_id => false)
        Task.should_receive(:new).with('these' => 'params', 'assigned_to_id' => user.id, 'created_by' => user).and_return(mock_task)

        post :create, :task => {'these' => 'params', 'assigned_to_id' => ''}
        assigns(:task).should be(mock_task)
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      request.env["HTTP_REFERER"] = '/back'
    end

    describe "with valid params" do
      it "updates the requested contact" do
        Task.should_receive(:find).with("37") { mock_task }
        mock_task.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :task => {'these' => 'params'}
      end

      it "should redirects back" do
        Task.stub(:find) { mock_task(:update_attributes => true) }
        put :update, :id => "37"
        response.should redirect_to("/back")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested task" do
      Task.should_receive(:find).with("37") { mock_task }
      mock_task.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the contacts list" do
      Task.stub(:find) { mock_task }
      delete :destroy, :id => "1"
      response.should redirect_to(tasks_url)
    end
  end
end
