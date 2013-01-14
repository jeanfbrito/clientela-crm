class CreateContactImports < ActiveRecord::Migration
  def self.up
    create_table :contact_imports do |t|
      t.datetime :imported_at
      t.string :file_file_name, :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_imports
  end
end
