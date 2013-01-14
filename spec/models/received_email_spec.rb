require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReceivedEmail do
  should_have_one :note, :foreign_key => :related_email_id
end
