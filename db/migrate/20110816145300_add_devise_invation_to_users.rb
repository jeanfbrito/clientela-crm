class AddDeviseInvationToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string   :invitation_token, :limit => 60
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.index    :invitation_token
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :invitation_token
      t.remove :invitation_sent_at
      t.remove :invitation_accepted_at
    end
  end
end
