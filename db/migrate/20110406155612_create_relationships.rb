class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :entity_id
      t.string :entity_type
      t.references :contact
      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
