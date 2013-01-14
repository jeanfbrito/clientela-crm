class AddIndexToForeignKeysAndRelated < ActiveRecord::Migration
  def self.up
    add_index :addresses, :contact_id
    add_index :contacts, :company_id
    add_index :deals, :contact_id
    add_index :emails, :contact_id
    add_index :notes, [:notable_id, :notable_type]
    add_index :phones, :contact_id
    add_index :tasks, [:taskable_id, :taskable_type]
    add_index :tasks, :assigned_to_id
  end

  def self.down
    remove_index :addresses, :contact_id
    remove_index :contacts, :company_id
    remove_index :deals, :contact_id
    remove_index :emails, :contact_id
    remove_index :notes, [:notable_id, :notable_type]
    remove_index :phones, :contact_id
    remove_index :tasks, [:taskable_id, :taskable_type]
    remove_index :tasks, :assigned_to_id
  end
end
