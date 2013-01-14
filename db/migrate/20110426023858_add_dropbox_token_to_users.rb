class AddDropboxTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :dropbox_token, :string, :limit => 6
    add_index :users, :dropbox_token, :unique => true
    User.all.each(&:reset_dropbox_token!)
  end

  def self.down
    remove_column :users, :dropbox_token
  end
end
