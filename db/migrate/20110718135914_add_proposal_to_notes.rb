class AddProposalToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :proposal, :boolean
  end

  def self.down
    remove_column :notes, :proposal
  end
end
