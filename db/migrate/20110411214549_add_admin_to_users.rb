class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    User.find(:first, :order => 'id ASC').update_attribute(:admin, true) if User.all.any?
  end

  def self.down
    remove_column :users, :admin
  end
end
