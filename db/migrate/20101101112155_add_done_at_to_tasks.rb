class AddDoneAtToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :done_at, :datetime
  end

  def self.down
    remove_column :tasks, :done_at
  end
end
