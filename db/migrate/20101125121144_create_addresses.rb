class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.text :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :kind
      t.references :contact

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
