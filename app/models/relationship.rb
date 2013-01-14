class Relationship < ActiveRecord::Base
  attr_accessible :entity, :entity_id, :entity_type, :contact, :contact_id
  validates_presence_of :entity, :contact
  belongs_to :entity, :polymorphic => true
  belongs_to :contact
  scope :on_deals, where(:entity_type => 'Deal')
  scope :on_facts, where(:entity_type => 'Fact')
end
