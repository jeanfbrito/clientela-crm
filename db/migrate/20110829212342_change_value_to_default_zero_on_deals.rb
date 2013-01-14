class ChangeValueToDefaultZeroOnDeals < ActiveRecord::Migration
  def self.up
    change_column :deals, :value, :integer, :default => 0
  end

  def self.down
    change_column :deals, :value, :integer
  end
end
