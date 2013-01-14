class AddCompanyIdToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :company_id, :integer
  end

  def self.down
    remove_column :contacts, :company_id
  end
end
