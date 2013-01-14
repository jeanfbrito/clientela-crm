class UpdatePendingToProspectOnDealsStatus < ActiveRecord::Migration
  def self.up
    change_column_default(:deals, :status, 'prospect')
    execute("UPDATE deals SET status = 'prospect' WHERE status = 'pending'")
  end

  def self.down
    change_column_default(:deals, :status, 'pending')
    execute("UPDATE deals SET status = 'pending' WHERE status IN ('prospect','qualify','proposal','negotiation')")
  end
end
