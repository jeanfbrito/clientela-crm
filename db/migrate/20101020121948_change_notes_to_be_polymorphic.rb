class ChangeNotesToBePolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :notes, :contact_id, :notable_id
    add_column :notes, :notable_type, :string
    execute("update notes set notable_type = 'Contact'")
  end

  def self.down
    remove_column :notes, :notable_type
    rename_column :notes, :notable_id, :contact_id
  end
end
