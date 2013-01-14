require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Relationship do
  should_belong_to :entity, :polymorphic => true
  should_belong_to :contact
  should_validate_presence_of :entity
  should_validate_presence_of :contact
  it { Relationship.on_deals.to_sql.should == %{SELECT "relationships".* FROM "relationships" WHERE "relationships"."entity_type" = 'Deal'}}
  it { Relationship.on_facts.to_sql.should == %{SELECT "relationships".* FROM "relationships" WHERE "relationships"."entity_type" = 'Fact'}}
end
