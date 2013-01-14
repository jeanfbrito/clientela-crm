class UpdateDealsWithAssignedToIfNull < ActiveRecord::Migration
  def self.up
    execute("UPDATE deals SET assigned_to_id = #{User.first.id} WHERE assigned_to_id IS NULL")
  end

  def self.down
  end
end
