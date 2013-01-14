require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Activity do
  should_belong_to :activitable, :polymorphic => true
  should_belong_to :author, :class_name => "User"
  should_have_scope :latest

  describe "set_current_user" do
    describe do
      before(:each) do
        @user = FactoryGirl.create(:quentin)
        Thread.current[:current_user] = @user.id
      end
      
      it "should set author_id and author_name when Thread.current[:current_user] is set" do
        activity = Activity.create!(:activitable => FactoryGirl.create(:task_today), :action => "create")
        activity.author.should == @user
        activity.author_name.should == "Quentin Tarantino"
      end

      it "should not override given user" do
        user = FactoryGirl.create(:fake)
        activity = Activity.create!(:activitable => FactoryGirl.create(:task_today), :action => "create", :author_id => user.id)
        activity.author.should == user
      end
    end

    it "should not set user_id if Thread.current[:current_user] is not set" do
      Thread.current[:current_user] = nil
      activity = Activity.create!(:activitable => FactoryGirl.create(:task_today), :action => "create")
      activity.author.should be_nil
    end
  end

  describe "parent name" do
    it "should return parent name" do
      Activity.new(:parent => {:name => "Quentin"}).parent_name.should == "Quentin"
    end

    it "should return nil if parent is nil" do
      Activity.new.parent_name.should be_nil
    end
  end

  describe "record content" do
    it "should return record content" do
      Activity.new(:record => {:content => "some content"}).record_content.should == "some content"
    end

    it "should return nil if record content is nil" do
      Activity.new.record_content.should be_nil
    end
  end

  describe "params for parent url" do
    it "should return array with params" do
      Activity.new(:parent => {:type => "contact", :id => 42}).params_for_parent_url.should == ["contact_url", 42]
    end

    it "should return nil if parent is nil" do
      Activity.new.params_for_parent_url.should be_nil
    end
  end

  describe "params for record url" do
    it "should return array with params" do
      Activity.new(:record => {:type => "contact", :id => 42}).params_for_record_url.should == ["contact_url", 42]
    end

    it "should return nil if record is nil" do
      Activity.new.params_for_record_url.should be_nil
    end
  end

  describe "record name" do
    it "should return record name" do
      Activity.new(:record => {:name => "Quentin"}).record_name.should == "Quentin"
    end

    it "should return nil if record is nil" do
      Activity.new.record_name.should be_nil
    end
  end
end
