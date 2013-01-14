require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksHelper do
  describe "task_params" do
    def default_params
      {:format=>:js}
    end

    context "when NameError is raised" do
      it "should return default params" do
        helper.task_params.should == default_params
      end
    end

    context "when ActiveRecord::RecordNotFound os raised" do
      it "should return default params" do
        helper.should_receive(:resource).and_raise(ActiveRecord::RecordNotFound)
        helper.task_params.should == default_params
      end
    end

    context "when there is a valid resource" do
      context "contact" do
        let!(:joseph) { FactoryGirl.create(:contact_joseph, imported_by_id: nil) }
        it "should return valid taskable_type and taskable id" do
          helper.stub!(:resource).and_return(joseph)
          helper.task_params.should == {:task => {:taskable_id => joseph.id, :taskable_type => "Entity"}, :format=>:js}
        end
      end
      context "company" do
        let!(:helabs) { FactoryGirl.create(:entity_helabs) }
        it "should return valid taskable_type and taskable id" do
          helper.stub!(:resource).and_return(helabs)
          helper.task_params.should == {:task => {:taskable_id => helabs.id, :taskable_type => "Entity"}, :format=>:js}
        end
      end
      context "deal" do
        let!(:deal) { FactoryGirl.create(:quentin_deal_won) }
        it "should return valid taskable_type and taskable id" do
          helper.stub!(:resource).and_return(deal)
          helper.task_params.should == {:task => {:taskable_id => deal.id, :taskable_type => "Deal"}, :format=>:js}
        end
      end
    end
  end

  describe "current_tasks" do
    before(:each) do
      @taskable = mock('taskable-item')
      @taskable.stub!(:tasks).and_return(['tasks-mock'])
    end

    context "when resource is defined" do
      it "should return resource tasks" do
        helper.stub!(:resource).and_return(@taskable)
        helper.current_tasks.should == ['tasks-mock']
      end
    end

    context "when resource is not defined" do
      it "should return current_user tasks" do
        helper.stub!(:current_user).and_return(@taskable)
        helper.current_tasks.should == ['tasks-mock']
      end
    end
  end

  describe "users_for_task_filter" do
    let!(:quentin) { FactoryGirl.create(:quentin) }
    let!(:fake) { FactoryGirl.create(:fake) }
    it "should return all and me first" do
      helper.stub!(:t).and_return("i18n")
      helper.stub!(:current_user).and_return(quentin)
      helper.users_for_task_filter.should == %{<option value="">i18n</option>\n<option value="#{quentin.id}">i18n</option>\n<option value="#{fake.id}">Fake User</option>}
    end
  end

  describe "task_category" do
    it "should return empty if no category" do
      task = mock_model(Task, :category => nil)
      helper.task_category(task).should be_nil
    end

    it "should return span with category" do
      task = mock_model(Task, :category => TaskCategory.new(:name => "Call", :color => "010101"))
      helper.task_category(task).should == %{<span class="category" style="background: #010101">Call</span>}
    end
  end

  describe "task_format" do
    it "should not show hour if not specified datetime" do
      task = FactoryGirl.create(:not_specified_datetime)
      date = task.due_at.strftime("%d %b")
      helper.task_format(task).should == "<strong>#{date}</strong> &ndash; blas"
    end

    it "should show hour if specified datetime" do
      task = FactoryGirl.create(:specified_datetime)
      date = task.due_at.strftime("%d %b")
      hour = task.due_at.strftime("%H:%Mh")
      helper.task_format(task).should == "<strong>#{date}</strong>, #{hour} &ndash; blas"
    end

    it "should not show day or time when is today and not specified datetime" do
      task = FactoryGirl.create(:task_today)
      helper.task_format(task).should == "blas"
    end

    it "should not show day when is today and specified datetime" do
      task = FactoryGirl.create(:task_today)
      task.update_attribute(:frame, true)
      hour = task.due_at.strftime("%H:%Mh")
      helper.task_format(task).should == "<strong>#{hour}</strong> &ndash; blas"
    end
  end
end
