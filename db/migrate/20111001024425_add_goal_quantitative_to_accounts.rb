class AddGoalQuantitativeToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :goal_quantitative, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :goal_quantitative
  end
end
