class AddImportedByIdOnContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :imported_by_id, :integer
  end

  def self.down
    remove_column :contacts, :imported_by_id
  end
end
