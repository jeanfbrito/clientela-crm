class AddKindToContactImports < ActiveRecord::Migration
  def self.up
    add_column :contact_imports, :kind, :string
  end

  def self.down
    remove_column :contact_imports, :kind
  end
end
