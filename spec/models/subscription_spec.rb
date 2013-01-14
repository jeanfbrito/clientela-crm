require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subscription do
  should_belong_to :subject, :polymorphic => true
  should_belong_to :subscriber, :class_name => "User"
end
