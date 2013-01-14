class AddingDefaultValueToDealsDuration < ActiveRecord::Migration
  def self.up
    change_column :deals, :duration, :integer, :default => 0
  end

  def self.down
    change_column :deals, :duration, :integer
  end
end
