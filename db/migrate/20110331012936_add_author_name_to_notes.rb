class AddAuthorNameToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :author_name, :string
    
    execute("UPDATE notes n, users u SET n.author_name = u.name WHERE n.author_id = u.id")
    execute("UPDATE notes n, users u SET n.author_name = '#{User.first.name}' WHERE n.author_id <> u.id") if User.first
  end

  def self.down
    remove_column :notes, :author_name
  end
end
