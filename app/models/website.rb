class Website < ActiveRecord::Base
  KINDS = ["work", "personal", "blog", "other"]
  attr_accessible :url, :kind
  belongs_to :entity
  validates :url, :presence => true
  validates :kind, :inclusion => KINDS

  def self.kinds
    KINDS
  end
end