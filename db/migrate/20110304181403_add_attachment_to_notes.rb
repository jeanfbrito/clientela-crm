class AddAttachmentToNotes < ActiveRecord::Migration
  def self.up
    change_table(:notes) do |t|
      t.string :attachment_file_name, :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
    end
  end

  def self.down
    change_table(:notes) do |t|
      t.remove :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at
    end
  end
end
