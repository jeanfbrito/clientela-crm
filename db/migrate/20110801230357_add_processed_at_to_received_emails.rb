class AddProcessedAtToReceivedEmails < ActiveRecord::Migration
  def self.up
    add_column :received_emails, :processed_at, :datetime
    execute("UPDATE received_emails SET processed_at = created_at")
  end

  def self.down
    drop_column :received_emails, :processed_at
  end
end
