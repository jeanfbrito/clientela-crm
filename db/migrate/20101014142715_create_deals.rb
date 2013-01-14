class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.integer :contact_id
      t.string  :name
      t.text    :description
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
