class AddStatusLastChangeAtToDeals < ActiveRecord::Migration
  def self.up
    add_column :deals, :status_last_change_at, :datetime
    execute("UPDATE deals SET status_last_change_at = updated_at")
  end

  def self.down
    remove_column :deals, :status_last_change_at
  end
end
