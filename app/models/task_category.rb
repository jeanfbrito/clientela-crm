class TaskCategory < ActiveRecord::Base
  default_scope order('name asc')
  validates :name, :color, :presence => true
end
