require File.dirname(__FILE__) + '/../spec_helper'

describe DebugHelper do
  it "should work" do
    stub!(:p)
    p80 "a"
  end
end