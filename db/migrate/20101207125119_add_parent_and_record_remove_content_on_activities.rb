class AddParentAndRecordRemoveContentOnActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :parent, :text
    add_column :activities, :record, :text
    remove_column :activities, :content
  end

  def self.down
    add_column :activities, :content, :text
    remove_column :activities, :record
    remove_column :activities, :parent
  end
end
