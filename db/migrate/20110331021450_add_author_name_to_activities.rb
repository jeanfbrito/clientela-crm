class AddAuthorNameToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :author_name, :string
    
    execute("UPDATE activities n, users u SET n.author_name = u.name WHERE n.author_id = u.id")
    execute("UPDATE activities n, users u SET n.author_name = '#{User.first.name}' WHERE n.author_id <> u.id") if User.first
  end

  def self.down
    remove_column :activities, :author_name
  end
end
