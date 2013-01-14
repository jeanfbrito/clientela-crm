# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do

  let!(:account) { FactoryGirl.create(:example) }
  let!(:quentin) { FactoryGirl.create(:quentin) }

  before do
    Account.current = account
  end

  should_validate_presence_of :content
  should_validate_presence_of :due_at
  should_validate_presence_of :assigned_to

  should_belong_to :taskable, :polymorphic => true
  should_belong_to :assigned_to, :class_name => "User"
  should_have_many :activities, :as => :activitable
  should_belong_to :category, :class_name => "TaskCategory"

  should_have_scope :completed
  should_have_scope :uncompleted
  it { Task.assigned_to(quentin).to_sql.should == %{SELECT "tasks".* FROM "tasks" WHERE "tasks"."assigned_to_id" = #{quentin.id}} }
  it { Task.assigned_to_id(quentin.id).to_sql.should == %{SELECT "tasks".* FROM "tasks" WHERE "tasks"."assigned_to_id" = #{quentin.id}} }
  it { Task.due_on(Date.new(2011,10,10)).to_sql.should == %{SELECT "tasks".* FROM "tasks" WHERE "tasks"."done_at" IS NULL AND (due_at BETWEEN '2011-10-10 00:00:00.000000' AND '2011-10-10 23:59:59.999999') ORDER BY due_at DESC} }

  describe "should return tasks" do
    let!(:today) { FactoryGirl.create(:task_today) }
    let!(:not_specified) { FactoryGirl.create(:not_specified_datetime) }
    let!(:specified_datetime) { FactoryGirl.create(:specified_datetime) }
    let!(:tomorrow) { FactoryGirl.create(:task_tomorrow) }
    let!(:pending) { FactoryGirl.create(:task_pending) }

    #FIXME: Why is this here and also on around line 20?
    it { should have_scope(:uncompleted) }#.where(:done => false) }
    #  should_have_default_scope :order => 'due_at desc'

    it "should return today tasks" do
      Task.today.should == [today]
    end

    it "should return future tasks" do
      Task.future.should == [not_specified, specified_datetime, tomorrow]
    end

    it "should return incomplete tasks" do
      Task.pending.should == [pending]
    end
  end

  describe "taskable?" do
    context "when task is associated to a taskable" do
      it "should return true" do
        FactoryGirl.create(:not_specified_datetime).should be_taskable
      end
    end

    context "when there is no association with a taskable" do
      it "should return false" do
        FactoryGirl.create(:specified_datetime).should_not be_taskable
        FactoryGirl.create(:task_today).should_not be_taskable
      end
    end
  end

  describe "today?" do
    it "should return true when today" do
      FactoryGirl.create(:task_today).should be_today
    end

    it "should return true when today" do
      FactoryGirl.create(:task_tomorrow).should_not be_today
    end
  end

  describe "task_assignment_notification" do
    it "should send when created_by is not the assigned user" do
      lambda do
        create_task(:assigned_to => quentin, :created_by => FactoryGirl.create(:fake), :due_at => Time.now)
      end.should change(ActionMailer::Base.deliveries, :size).by(1)
      ActionMailer::Base.deliveries.last.body.should =~ /Olá Quentin Tarantino,\n\nA tarefa \"My task\" foi enviada por Fake User/
    end

    it "should not send when current_user is the assigned user" do
      lambda do
        create_task(:assigned_to => quentin, :created_by => quentin, :due_at => Time.now)
      end.should_not change(ActionMailer::Base.deliveries, :size)
    end
  end

  describe "due_values" do
    it "should return due kinds" do
      Task.due_values.should == [:today, :tomorrow, :this_week, :next_week, :specific_date_time]
    end
  end

  describe "follow_up_due_values" do
    it "should return due kinds" do
      Task.follow_up_due_values.should == [:in_1_week, :in_1_month, :in_2_months, :in_3_months, :in_6_months]
    end
  end

  describe "notify_values" do
    it "should return notify_values kinds" do
      Task.notify_values.should == [:exact_time, :one_hour, :two_hour, :three_hour, :morning, :day_before, :week_before, :never]
    end
  end

  describe "complete" do
    before(:each) do
      @task = FactoryGirl.create(:task_today)
    end

    it "should update done_date to current date" do
      Timecop.freeze(Time.now) do
        expect{@task.complete}.to change(@task, :done_at).to(Time.now)
      end
    end
  end

  describe "due virtual field" do
    describe "setter" do
      it "should return same value" do
        task = Task.new
        (task.due = :x).should == :x
      end
    end

    describe "getter" do
      it "should return :today when new_record?" do
        Task.new.due.should == :today
      end

      it "should return :specific_date_time when not new_record?" do
        FactoryGirl.create(:specified_datetime).due.should == :specific_date_time
        Task.new.due.should == :today
      end
    end
  end

  describe "set_notify_at" do
   {
     :exact_time => :today_at_midnight,
     :one_hour => :today_at_11pm,
     :two_hour => :today_at_10pm,
     :three_hour => :today_at_9pm,
     :morning => :today_at_9_am,
     :day_before => :yesterday_at_18_pm,
     :week_before => :week_before_at_18_pm,
     :never => :never_nil
    }.each do |notify, result|
      it "should set notify_at to #{notify} early than due_at" do
        create_task(:notify => notify, :due_at => 0.days.from_now.end_of_day).notify_at.should == send(result)
      end
    end

    def never_nil
      nil
    end

    def today_at_midnight
      0.days.from_now.end_of_day
    end

    def today_at_11pm
      0.days.from_now.end_of_day - 1.hour
    end

    def today_at_10pm
      0.days.from_now.end_of_day - 2.hour
    end

    def today_at_9pm
      0.days.from_now.end_of_day - 3.hour
    end

    def today_at_9_am
      0.days.from_now.at_beginning_of_day + 9.hour
    end

    def yesterday_at_18_pm
      1.day.ago.at_beginning_of_day + 18.hour
    end

    def week_before_at_18_pm
      7.days.ago.end_of_week-2.days-6.hours+1.second
    end
  end

  describe "users task notification" do
    describe "notify users" do
      let!(:today) { FactoryGirl.create(:task_today) }

      before(:each) do
        account = FactoryGirl.create(:example)
        Account.should_receive(:all).and_return([account])

        ActionMailer::Base.deliveries = []
        Task.should_receive(:notifiable_tasks).and_return([today])
        Task.notify_users
      end

      it "should notify about tasks with due in two hours" do
        ActionMailer::Base.deliveries.count.should == 1
      end

      it "should change notified to true" do
        today.should be_notified
      end
    end

    describe "notifiable tasks" do
      let!(:today) { FactoryGirl.create(:task_today, notify_at: 20.minutes.ago) }

      it "should return uncompleted tasks not alredy notified and with notify_at on the past" do
        Task.notifiable_tasks.should eq([today])
      end
    end
  end

  def create_task(options)
    default_options = {:content => "My task", :assigned_to => quentin, :created_by => quentin}
    Task.create!(default_options.merge(options))
  end
end
