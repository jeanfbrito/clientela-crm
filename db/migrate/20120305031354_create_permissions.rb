class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.references :group
      t.references :referred, :polymorphic => true

      t.timestamps
    end
    add_index :permissions, [:group_id, :referred_id, :referred_type], :unique => true
  end

  def self.down
    drop_table :permissions
  end
end
