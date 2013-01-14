class AddTypeToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :type, :string
    execute("UPDATE contacts SET type = 'Contact'")
  end

  def self.down
    remove_column :contacts, :type
  end
end
