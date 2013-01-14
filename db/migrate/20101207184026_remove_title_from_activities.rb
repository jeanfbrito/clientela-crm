class RemoveTitleFromActivities < ActiveRecord::Migration
  def self.up
    remove_column :activities, :title
  end

  def self.down
    add_column :activities, :title, :string
  end
end