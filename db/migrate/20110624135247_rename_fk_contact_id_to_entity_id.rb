class RenameFkContactIdToEntityId < ActiveRecord::Migration
  def self.up
    rename_column(:emails, :contact_id, :entity_id)
    rename_column(:websites, :contact_id, :entity_id)
    rename_column(:phones, :contact_id, :entity_id)
    rename_column(:addresses, :contact_id, :entity_id)
  end

  def self.down
    rename_column(:emails, :entity_id, :contact_id)
    rename_column(:websites, :entity_id, :contact_id)
    rename_column(:phones, :entity_id, :contact_id)
    rename_column(:addresses, :entity_id, :contact_id)
  end
end
