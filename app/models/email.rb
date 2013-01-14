class Email < ActiveRecord::Base
  attr_accessible :address, :kind, :contact
  belongs_to :entity
  validates :address, :presence => true
  validates :kind, :presence => true
  
  def self.kinds
    [:work, :home, :other]
  end
end
