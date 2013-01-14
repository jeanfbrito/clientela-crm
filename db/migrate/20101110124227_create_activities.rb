class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :activitable_id
      t.string  :activitable_type
      t.string  :action
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
