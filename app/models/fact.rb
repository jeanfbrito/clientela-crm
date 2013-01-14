class Fact < ActiveRecord::Base
  attr_accessible :name, :description, :tag_list, :closed_at

  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :tasks, :as => :taskable, :dependent => :destroy
  has_many :relationships, :as => :entity, :dependent => :destroy
  has_many :contacts, :through => :relationships
  has_many :subscriptions, :as => :subject, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :class_name => "User"

  validates :name, :presence => true

  scope :opened, where(:closed_at => nil)
  scope :closed, where("closed_at is not null")

  acts_as_taggable_with_grouped_by_initial

  define_index do
    indexes name, description
  end

  def special_fields
    @special_fields = []
    description.lines.each do |line|
      @special_fields << [$1, $2.strip] if /^(.*):(.*)$/.match(line)
    end
    @special_fields
  end

  def only_description
    result = description.lines.reject { |line| /^(.*):(.*)$/.match(line) }
    result.delete_at(0) if result[0].blank?
    result.join
  end
end
