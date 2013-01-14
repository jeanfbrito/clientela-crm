class AddRelatedEmailIdToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :related_email_id, :integer
  end

  def self.down
    remove_column :notes, :related_email_id
  end
end
