class AddClosedAtToFacts < ActiveRecord::Migration
  def self.up
    add_column :facts, :closed_at, :datetime
  end

  def self.down
    remove_column :facts, :closed_at
  end
end
