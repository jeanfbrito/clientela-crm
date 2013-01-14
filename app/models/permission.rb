class Permission < ActiveRecord::Base
  attr_accessible :group, :group_id, :referred, :referred_id, :referred_type
  validates :group, :presence => true
  belongs_to :group
  belongs_to :referred, :polymorphic => true
end
