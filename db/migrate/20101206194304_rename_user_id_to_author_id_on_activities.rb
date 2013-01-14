class RenameUserIdToAuthorIdOnActivities < ActiveRecord::Migration
  def self.up
    rename_column :activities, :user_id, :author_id
  end

  def self.down
    rename_column :activities, :author_id, :user_id
  end
end
