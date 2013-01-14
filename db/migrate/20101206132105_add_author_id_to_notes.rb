class AddAuthorIdToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :author_id, :integer
  end

  def self.down
    remove_column :notes, :author_id
  end
end
