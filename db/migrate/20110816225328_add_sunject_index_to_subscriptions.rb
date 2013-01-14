class AddSunjectIndexToSubscriptions < ActiveRecord::Migration
  def self.up
    remove_index :subscriptions, [:subject_id, :subject_type]
    add_index :subscriptions, [:subject_id, :subject_type, :subscriber_id], :name => "index_subscription_on_subscriber_and_subject", :unique => true
  end

  def self.down
    remove_index :subscriptions, :name => "index_subscription_on_subscriber_and_subject"
    add_index :subscriptions, [:subject_id, :subject_type, :subscriber_id], :name => "index_subscription_on_subscriber_and_subject"
  end
end
