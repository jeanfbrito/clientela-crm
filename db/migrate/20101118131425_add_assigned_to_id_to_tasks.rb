class AddAssignedToIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :assigned_to_id, :integer
  end

  def self.down
    remove_column :tasks, :assigned_to_id
  end
end
