class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.references :subject, :polymorphic => true
      t.references :subscriber
      t.timestamps
    end
    add_index :subscriptions, [:subject_id, :subject_type]
  end

  def self.down
    drop_table :subscriptions
  end
end
