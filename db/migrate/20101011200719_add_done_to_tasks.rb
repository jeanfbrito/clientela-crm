class AddDoneToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :done, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :done
  end
end
