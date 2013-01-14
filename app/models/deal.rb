class Deal < ActiveRecord::Base
  VALUE_TYPES = %w(fixed hourly monthly yearly)
  STATUSES = %w(prospect qualify proposal negotiation lost won)
  attr_accessible :name, :description, :contact, :value, :value_type, :status, :duration, :contact_id, :tag_list, :assigned_to_id, :assigned_to, :probability, :contact_name, :permissions_attributes

  has_many :activities, :as => :activitable
  has_many :permissions, :as => :referred, :dependent => :destroy
  has_many :groups, :through => :permissions
  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  has_many :relationships, :dependent => :destroy, :as => :entity
  has_many :contacts, :through => :relationships
  has_many :subscriptions, :as => :subject, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :class_name => "User"
  belongs_to :assigned_to, :class_name => "User"

  accepts_nested_attributes_for :permissions, :allow_destroy => true, :reject_if => proc { |attributes| attributes['group_id'].blank? }

  validates :name, :value, :assigned_to, :presence => true
  validates :status, :inclusion => { :in => STATUSES }
  validates :value_type, :inclusion => { :in => VALUE_TYPES }, :allow_nil => true
  validates :probability, :inclusion => { :in => 0..100 }

  scope :pending, :conditions => ["status NOT IN ('won','lost')"], :extend => DealTotalExtension
  STATUSES.each do |status|
    scope status.to_sym, :conditions => {:status => status}, :extend => DealTotalExtension
  end

  scope :created_between, lambda { |from,to| where("created_at BETWEEN ? AND ?", from.beginning_of_day,to.end_of_day) }
  scope :won_between, lambda { |from,to| won.where("status_last_change_at BETWEEN ? AND ?", from.beginning_of_day,to.end_of_day) }

  before_save :update_status_last_change_at, :update_probability
  before_create :set_permissions_to_contact

  acts_as_taggable_with_grouped_by_initial

  define_index do
    indexes name, description
  end

  def total_value
    if self.value_type == 'fixed'
      self.value
    else
      self.value * self.duration
    end
  end

  def contact_name
    @contact_name
  end

  def contact_name=(name)
    return name if name.blank?
    @contact_name = name

    unless contact = Contact.find_by_name(name)
      contact = Contact.create(:name => name)
      @set_permissions_to_contact = contact
    end
    contacts << contact
  end

  def set_permissions_to_contact
    return unless @set_permissions_to_contact
    self.permissions.each do |permission|
      @set_permissions_to_contact.permissions.create!(:group => permission.group)
    end
  end

  class << self
    def value_types
      VALUE_TYPES
    end

    def statuses
      STATUSES
    end

    def quantitative_data(year, goal)
      data = []
      (1..12).each do |month|
        from_date   = Date.new(year, month, 1)
        to_date     = Date.new(year, month, -1)
        data << [abbr_i18n(to_date, :abbr_month)].concat(calculate_quantitative_by_date(from_date,to_date)).concat([goal])
      end
      concat_with_goal(data, goal)
    end

    def qualitative_data(year, goal)
      data = []
      (1..12).each do |month|
        from_date   = Date.new(year, month, 1)
        to_date     = Date.new(year, month, -1)
        data << [abbr_i18n(to_date, :abbr_month)].concat(calculate_qualitavide_by_date(from_date,to_date)).concat([goal])
      end
      concat_with_goal(data, goal)
    end

    def report_values
      [:week, :month, :year]
    end

    private
    def concat_with_goal(data, goal)
      [["",0,0,goal]].concat(data).concat([["",0,0,goal]])
    end

    def calculate_quantitative_by_date(from,to)
  		wons  = Deal.won_between(from,to).count
  		all   = Deal.created_between(from,to).count
  		[all, wons]
    end

    def calculate_qualitavide_by_date(from,to)
      wons  = Deal.won_between(from,to).map(&:total_value).reduce(0,:+)
      all   = Deal.created_between(from,to).map(&:total_value).reduce(0,:+)
      [all, wons]
    end

    def abbr_i18n(date, format)
      I18n.l(date, :format => format)
    end
  end

  private
  def update_status_last_change_at
    self.status_last_change_at = Time.now if status_changed? || status_last_change_at.blank?
  end

  def update_probability
    self.probability = 100 if status == 'won'
    self.probability = 0 if status == 'lost'
  end
end