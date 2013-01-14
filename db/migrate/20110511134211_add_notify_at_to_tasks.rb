class AddNotifyAtToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :notify_at, :datetime
    add_column :tasks, :notify, :string
    execute("UPDATE tasks SET notify_at = (due_at - INTERVAL 1 HOUR), notify = 'one_hour'")
  end

  def self.down
    remove_column :tasks, :notify_at
  end
end
