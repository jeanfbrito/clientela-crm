class ReceivedEmail < ActiveRecord::Base
  has_one :note, :foreign_key => :related_email_id
end
