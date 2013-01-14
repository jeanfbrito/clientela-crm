require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TaskObserver do
  let!(:task) { FactoryGirl.create(:task_today) }
  describe do
    def mock_task(stubs={})
      @mock_task ||= mock_model(Task, {:content => "Task description", :id => 6, :category => nil}.merge(stubs))
    end

    def record
      {:name => "Task description", :type => "task", :id => 6}
    end

    before(:each) do
      @obs = TaskObserver.instance
    end

    it "should create activity saving category" do
      mock_task(:category => TaskCategory.new(:name => "Call"))
      record = {:name => "Call: Task description", :type => "task", :id => 6}
      Activity.should_receive(:create).with(:activitable => mock_task, :action => "create", :record => record)
      @obs.after_create(mock_task)
    end

    it "should create new activity on create" do
      Activity.should_receive(:create).with(:activitable => mock_task, :action => "create", :record => record)
      @obs.after_create(mock_task)
    end

    it "should create new activity when done" do
      mock_task(:done_at_changed? => true)
      Activity.should_receive(:create).with(:activitable => mock_task, :action => "done", :record => record)
      @obs.before_update(mock_task)
    end
  end

  it "should not create new activity when not marking task as done" do
    lambda do
      task.update_attributes(:content => "new description")
    end.should_not change(Activity, :count)
  end
end
