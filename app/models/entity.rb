class Entity < ActiveRecord::Base
  has_many :phones,    :dependent => :destroy
  has_many :emails,    :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  has_many :websites,  :dependent => :destroy
  has_many :permissions, :as => :referred, :dependent => :destroy
  has_many :groups, :through => :permissions
  has_many :notes, :as => :notable, :dependent => :destroy
  has_many :subscriptions, :as => :subject, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :class_name => "User"

  has_attached_file :photo,
      :styles => { :small => ["50x50#", :png], :thumb => ["32x32#", :png], :mini_thumb => ["14x14#", :png] },
      :url   => :path_to_url,
      :default_url => '/images/avatar_:style.png'
  validates_attachment_content_type :photo, :content_type => ['image/png', 'image/gif', 'image/jpg', 'image/x-png', 'image/pjpeg', 'image/jpeg']
  validates_attachment_size :photo, :less_than => 1.megabyte

  acts_as_taggable_with_grouped_by_initial

  accepts_nested_attributes_for :phones, :allow_destroy => true,  :reject_if => proc { |attributes| attributes['number'].blank? }
  accepts_nested_attributes_for :emails, :allow_destroy => true,  :reject_if => proc { |attributes| attributes['address'].blank? }
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => proc { |attributes| attributes.slice('street', 'city', 'state', 'zip').values.join.blank? }
  accepts_nested_attributes_for :websites, :allow_destroy => true,  :reject_if => proc { |attributes| attributes['url'].blank? }
  accepts_nested_attributes_for :permissions, :allow_destroy => true, :reject_if => proc { |attributes| attributes['group_id'].blank? }

  def small_avatar
    photo.url(:small)
  end
  private
  def path_to_url
    "/system/accounts/contacts/:attachment/:id/:style/:filename"
  end
end
