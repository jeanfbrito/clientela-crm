class AddGoalQualitativeToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :goal_qualitative, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :goal_qualitative
  end
end
