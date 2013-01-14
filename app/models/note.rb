class Note < ActiveRecord::Base
  attr_accessible :content, :notable, :notable_id, :notable_type, :author, :created_at, :attachment, :related_email, :proposal, :notifications
  attr_writer :notifications
  belongs_to :notable, :polymorphic => true
  belongs_to :author, :class_name => "User"
  belongs_to :related_email, :class_name => "ReceivedEmail"
  has_many :activities, :as => :activitable
  validates :content, :author, :presence => true
  before_save :set_author_name
  after_create :create_subscriptions

  scope :with_image, :conditions => "attachment_content_type like 'image%'"
  scope :proposal, where(:proposal => true)
  default_scope :order => 'created_at DESC'

  has_attached_file :attachment,
      :whiny => false,
      :styles => { :slideshow => ["800x600", :png], :thumb => ["50x50#", :png] },
      :url   => "/system/accounts/notes/:id/:style/:filename",
      :storage => :s3,
      :bucket => ENV['AMAZON_S3_BUCKET'],
      :path => "/system/accounts/notes/:id/:style/:filename",
      :s3_credentials => {
        :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
      }
  validates_attachment_size :attachment, :less_than => 10.megabytes

  def notifications
    @notifications ||= {}
  end

  def unquoted_content
    if content =~ /(.*)^\d{4}\/\d{1,2}.*/m
      $1
    else
      content
    end
  end

  private
  def create_subscriptions
    notifications.each_key do |user_id|
      self.notable.subscriptions.find_or_create_by_subscriber_id(user_id) if User.find_by_id(user_id)
    end
  end
  def set_author_name
    self.author_name = author.name unless author.nil?
  end
end
