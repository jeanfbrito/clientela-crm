class Activity < ActiveRecord::Base
  belongs_to :activitable, :polymorphic => true
  belongs_to :author, :class_name => "User"
  scope :latest, order("created_at DESC")
  before_create :set_author_id, :set_author_name
  serialize :parent
  serialize :record

  def parent_name
    parent && parent[:name]
  end

  def params_for_parent_url
    parent && ["#{parent[:type]}_url", parent[:id]]
  end

  def record_content
    record && record[:content]
  end

  def record_name
    record && record[:name]
  end

  def params_for_record_url
    record && ["#{record[:type]}_url", record[:id]]
  end

  private
  def set_author_id
    self.author_id = Thread.current[:current_user] unless self.author
  end

  def set_author_name
    self.author_name = author.name if self.author
  end
end
