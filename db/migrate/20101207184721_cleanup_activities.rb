class CleanupActivities < ActiveRecord::Migration
  def self.up
    execute("TRUNCATE activities")
  end

  def self.down
  end
end
