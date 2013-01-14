require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Campaign do
  should_have_many :notes
  should_have_many :tasks
  should_validate_presence_of :name
  should_validate_inclusion_of :status, :in => ["planned", "started", "completed", "hold", "canceled"], :allow_blank => false
end