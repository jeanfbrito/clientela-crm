class AddDefaultPermissionsToDeals < ActiveRecord::Migration
  def self.up
    Deal.all.each do |deal|
      next unless deal.permissions.empty?
      User.active.all.each { |user| Permission.create!(:group => user.groups.where(:individual => true).first, :referred => deal) }
    end
  end

  def self.down
    Deal.all.each do |deal|
      deal.permissions.each do |permission|
        permission.destroy if permission.group.individual?
      end
    end
  end
end
