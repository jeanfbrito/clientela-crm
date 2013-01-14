class AddAssignedToIdToDeal < ActiveRecord::Migration
  def self.up
    add_column :deals, :assigned_to_id, :integer
  end

  def self.down
    remove_column :deals, :assigned_to_id, :integer
  end
end