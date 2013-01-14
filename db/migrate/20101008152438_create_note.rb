class CreateNote < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text :content
      t.integer :contact_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
