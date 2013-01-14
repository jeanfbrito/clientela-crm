class Task < ActiveRecord::Base
  attr_accessible :content, :taskable, :frame, :due_at, :assigned_to, :assigned_to_id, :due, :done_at, :taskable_id, :taskable_type, :category, :category_id, :notify, :created_by
  attr_accessor :created_by
  belongs_to :taskable, :polymorphic => true
  belongs_to :assigned_to, :class_name => "User"
  belongs_to :category, :class_name => "TaskCategory"
  has_many :activities, :as => :activitable
  validates :content, :due_at, :assigned_to, :presence => true
  scope :uncompleted, where(:done_at => nil).order('due_at DESC')
  scope :due_on, lambda { |date| uncompleted.where("due_at BETWEEN ? AND ?", date.beginning_of_day,date.end_of_day) }
  scope :completed, where("done_at is not null").order('done_at DESC')
  scope :assigned_to_id, lambda {|user_id| where(:assigned_to_id => user_id) }
  scope :assigned_to, lambda {|user| assigned_to_id(user.id) }
  before_validation :set_notify_at
  after_create :send_task_assignment_notification

  class << self
    def due_values
      [:today, :tomorrow, :this_week, :next_week, :specific_date_time]
    end

    def follow_up_due_values
      [:in_1_week, :in_1_month, :in_2_months, :in_3_months, :in_6_months]
    end

    def notify_values
      [:exact_time, :one_hour, :two_hour, :three_hour, :morning, :day_before, :week_before, :never]
    end

    def today
      Task.uncompleted.select {|t| t.due_at.to_date == Date.today}
    end

    def future
      Task.uncompleted.select {|t| t.due_at.to_date > Date.today}
    end

    def pending
      Task.uncompleted.select {|t| t.due_at.to_date < Date.today}
    end

    def notify_users
      Account.all.each do |account|
        notifiable_tasks.each do |task|
          UserMailer.task_notification(task).deliver
          task.update_attribute(:notified, true)
        end
      end
    end

    def notifiable_tasks
      Task.uncompleted.where("notify_at <= ? AND notified = ?", Time.now.utc, false)
    end
  end

  def today?
    due_at.to_date == Date.today
  end

  def due=(value)
    value
  end

  def due
    new_record? ? :today : :specific_date_time
  end

  def complete
    update_attributes(:done_at => Time.now)
  end

  def taskable?
    !self.taskable.nil? rescue false
  end

  private
  class NotifyAt
    class << self
      def exact_time(due_at)
        due_at
      end

      def one_hour(due_at)
        due_at - 1.hour
      end

      def two_hour(due_at)
        due_at - 2.hour
      end

      def three_hour(due_at)
        due_at - 3.hour
      end

      def morning(due_at)
        due_at.at_beginning_of_day + 9.hour
      end

      def day_before(due_at)
        (due_at - 1.day).at_beginning_of_day + 18.hour
      end

      def week_before(due_at)
        (due_at - 7.day).end_of_week-2.days-6.hours+1.second
      end

      def never(due_at)
        nil
      end
    end
  end

  def set_notify_at
    return if self.due_at.blank? || self.notify.blank?
    self.notify_at = NotifyAt.send(notify.to_s, due_at)
  end

  def send_task_assignment_notification
    UserMailer.task_assignment_notification(self, self.created_by).deliver unless assigned_to_itself?
  end

  def assigned_to_itself?
    self.created_by == self.assigned_to
  end
end
