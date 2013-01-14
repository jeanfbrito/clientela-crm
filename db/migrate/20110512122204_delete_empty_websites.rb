class DeleteEmptyWebsites < ActiveRecord::Migration
  def self.up
    execute("DELETE FROM websites WHERE url IS NULL")
  end

  def self.down
  end
end
