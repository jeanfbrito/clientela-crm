class AddWelcomeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :welcome, :boolean, :default => true
  end

  def self.down
    remove_column :users, :welcome
  end
end