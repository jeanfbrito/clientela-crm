class RemoveTimestampsFromGroupsUsers < ActiveRecord::Migration
  def self.up
    change_table :groups_users do |t|
      t.remove :created_at, :updated_at
    end
  end

  def self.down
    change_table :groups_users do |t|
      t.timestamps
    end
  end
end
