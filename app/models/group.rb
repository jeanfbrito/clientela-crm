class Group < ActiveRecord::Base
  attr_accessible :name, :user_ids, :individual
  has_and_belongs_to_many :users
  has_many :permissions, :dependent => :destroy
  validates :name, :presence => true
  scope :individual, where(:individual => true)
  scope :not_individual, where(:individual => false)
end
