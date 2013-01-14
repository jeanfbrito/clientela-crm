require 'spec_helper'

describe Group do
  should_validate_presence_of :name
  should_have_and_belong_to_many :users
  should_have_many :permissions, :dependent => :destroy
end
