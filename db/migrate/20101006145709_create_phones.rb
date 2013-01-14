class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |p|
      p.string :number
      p.string :kind
      p.integer :contact_id
      
      p.timestamps
    end
  end

  def self.down
    drop_table :phones
  end
end
