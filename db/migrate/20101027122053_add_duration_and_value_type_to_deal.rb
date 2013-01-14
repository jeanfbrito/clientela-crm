class AddDurationAndValueTypeToDeal < ActiveRecord::Migration
  def self.up
    add_column :deals, :value_type, :string
    add_column :deals, :duration, :integer
  end

  def self.down
    remove_column :deals, :duration
    remove_column :deals, :value_type
  end
end
