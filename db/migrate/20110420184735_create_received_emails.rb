class CreateReceivedEmails < ActiveRecord::Migration
  def self.up
    create_table :received_emails do |t|
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :received_emails
  end
end
