require 'spec_helper'

describe Permission do
  should_validate_presence_of :group
  should_belong_to :group
  should_belong_to :referred, :polymorphic => true
end
