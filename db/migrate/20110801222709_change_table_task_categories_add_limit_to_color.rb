class ChangeTableTaskCategoriesAddLimitToColor < ActiveRecord::Migration
  def self.up
    change_column(:task_categories, :color, :string, :limit => 6)
  end

  def self.down
    change_column(:task_categories, :color, :string, :limit => 255)
  end
end
