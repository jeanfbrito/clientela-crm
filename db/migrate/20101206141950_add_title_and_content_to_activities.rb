class AddTitleAndContentToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :title, :string
    add_column :activities, :content, :text
  end

  def self.down
    remove_column :activities, :content
    remove_column :activities, :title
  end
end
