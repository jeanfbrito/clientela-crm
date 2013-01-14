class AddFrameToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :frame, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :frame
  end
end
