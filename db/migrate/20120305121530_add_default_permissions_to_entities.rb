class AddDefaultPermissionsToEntities < ActiveRecord::Migration
  def self.up
    Entity.all.each do |entity|
      next unless entity.permissions.empty?
      User.active.all.each { |user| Permission.create!(:group => user.groups.where(:individual => true).first, :referred => entity) }
    end
  end

  def self.down
    Entity.all.each do |entity|
      entity.permissions.each do |permission|
        permission.destroy if permission.group.individual?
      end
    end
  end
end
