class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |p|
      p.string :address
      p.string :kind
      p.integer :contact_id
      
      p.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
