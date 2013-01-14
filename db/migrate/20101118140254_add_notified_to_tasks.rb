class AddNotifiedToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :notified, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :notified
  end
end
