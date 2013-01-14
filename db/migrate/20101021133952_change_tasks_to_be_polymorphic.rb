class ChangeTasksToBePolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :contact_id, :taskable_id
    add_column :tasks, :taskable_type, :string
    execute("update tasks set taskable_type = 'Contact'")
  end

  def self.down
    remove_column :tasks, :taskable_type
    rename_column :tasks, :taskable_id, :contact_id
  end
end
