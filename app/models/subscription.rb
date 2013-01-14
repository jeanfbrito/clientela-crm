class Subscription < ActiveRecord::Base
  belongs_to :subject, :polymorphic => true
  belongs_to :subscriber, :class_name => "User"
end
