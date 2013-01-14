class CreateIndividualGroupsToEachUser < ActiveRecord::Migration
  def self.up
    add_column :groups, :individual, :boolean, :default => false
    User.reset_column_information
    User.active.all.each do |user|
      group = Group.new(:name => user.name)
      group.individual = true
      group.save!
      user.groups << group
    end
  end

  def self.down
    Group.where(:individual => true).destroy_all
    remove_column :groups, :individual
  end
end
