class AddLogToContactImports < ActiveRecord::Migration
  def self.up
    add_column :contact_imports, :log, :text
  end

  def self.down
    remove_column :contact_imports, :log
  end
end
