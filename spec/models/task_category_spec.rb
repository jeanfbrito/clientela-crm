require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TaskCategory do
  should_validate_presence_of :name
  should_validate_presence_of :color
#  should_have_default_scope :order => 'name asc'
end
