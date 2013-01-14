class Phone < ActiveRecord::Base
  attr_accessible :number, :kind, :contact
  belongs_to :entity
  validates :number, :presence => true
  validates :kind, :presence => true
  
  def self.kinds
    [:work, :home, :mobile, :nextel, :fax, :skype, :other]
  end
end
